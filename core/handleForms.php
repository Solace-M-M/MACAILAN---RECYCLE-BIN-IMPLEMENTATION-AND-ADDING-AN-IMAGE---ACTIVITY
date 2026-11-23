<?php

// ---------------------------------------------------------------
// handleForms.php - receives every form submission for BOTH tables:
//   add_studio / update_studio / delete_studio   (parent)
//   add_game   / update_game   / delete_game / restore_game  (child; delete = recycle bin)
// It validates, calls the model function, then redirects with a message.
// ---------------------------------------------------------------
require_once __DIR__ . '/dbConfig.php';
require_once __DIR__ . '/models.php';
require_once __DIR__ . '/auth.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    redirect('../index.php');                       // only POST requests are accepted
}
requireLogin('../');                                // nobody can add/edit/delete without logging in
$user = currentUser();                              // the logged-in user doing this action
$uid  = (int) $user['user_id'];

if (!csrfIsValid($_POST['csrf'] ?? null)) {         // CSRF protection
    setFlash('error', 'Your session expired. Please try again.');
    redirect('../index.php');
}

$action = $_POST['action'] ?? '';
$id     = (int) ($_POST['id'] ?? 0);

// Which UNIQUE column caused a duplicate-entry error (MySQL error 1062)?
function duplicateMessage(PDOException $ex): ?array {
    if (($ex->errorInfo[1] ?? 0) !== 1062) {
        return null;
    }
    $msg = $ex->errorInfo[2] ?? '';
    if (str_contains($msg, 'email'))       return ['email', 'Another studio already uses this email.'];
    if (str_contains($msg, 'studio_name')) return ['studio_name', 'A studio with this name already exists.'];
    if (str_contains($msg, 'uq_studio_title')) return ['title', 'This studio already has a game with that title (check the recycle bin too).'];
    return ['title', 'That record already exists.'];
}

try {
    switch ($action) {

        /* ===================== PARENT: studios ===================== */

        case 'add_studio':
            [$data, $errors] = validateStudio($_POST);
            if (!$errors) {
                try {
                    $newId = insertStudio($pdo, $data, $uid);
                    logActivity($pdo, $user, 'INSERT', 'studio', $newId, "Registered studio \"{$data['studio_name']}\"");
                    setFlash('success', "Studio \"{$data['studio_name']}\" was registered.");
                    redirect('../index.php');
                } catch (PDOException $ex) {
                    if (!$dup = duplicateMessage($ex)) { throw $ex; }
                    $errors[$dup[0]] = $dup[1];
                }
            }
            $_SESSION['old'] = $_POST;               // keep what the user typed
            $_SESSION['errors'] = $errors;
            redirect('../index.php');
            break;

        case 'update_studio':
            if (!getStudioById($pdo, $id)) {
                setFlash('error', 'That studio no longer exists.');
                redirect('../index.php');
            }
            [$data, $errors] = validateStudio($_POST);
            if (!$errors) {
                try {
                    updateStudio($pdo, $id, $data, $uid);
                    logActivity($pdo, $user, 'UPDATE', 'studio', $id, "Updated studio \"{$data['studio_name']}\"");
                    setFlash('success', "Studio #{$id} was updated.");
                    redirect('../index.php');
                } catch (PDOException $ex) {
                    if (!$dup = duplicateMessage($ex)) { throw $ex; }
                    $errors[$dup[0]] = $dup[1];
                }
            }
            $_SESSION['old'] = $_POST;
            $_SESSION['errors'] = $errors;
            redirect("../editStudio.php?id={$id}");
            break;

        case 'delete_studio':
            $studio = getStudioById($pdo, $id);
            $imagePaths = $studio ? getImagePathsByStudio($pdo, $id) : [];   // files to clean up
            if ($studio && deleteStudio($pdo, $id)) {
                array_map('deleteImageFile', $imagePaths);
                $n = (int) $studio['games_count'];
                logActivity($pdo, $user, 'DELETE', 'studio', $id, "Deleted studio \"{$studio['studio_name']}\" and its {$n} game(s)");
                setFlash('success', "Studio \"{$studio['studio_name']}\" was deleted along with its {$n} game(s).");
            } else {
                setFlash('error', 'That studio was already deleted.');
            }
            redirect('../index.php');
            break;

        /* ====================== CHILD: games ====================== */

        case 'add_game':
            [$data, $errors] = validateGame($_POST);
            $studioId = (int) $data['studio_id'];
            if (!$errors && !getStudioById($pdo, $studioId)) {
                $errors['studio_id'] = 'That studio does not exist.';   // keeps the foreign key valid
            }
            $imagePath = null;
            if (!$errors) {                                          // ONE image per game (optional)
                [$imagePath, $imageError] = saveGameImage($_FILES['image'] ?? null);
                if ($imageError) { $errors['image'] = $imageError; }
            }
            if (!$errors) {
                try {
                    $newId = insertGame($pdo, $data, $uid);
                    if ($imagePath) { setGameImage($pdo, $newId, $imagePath); }
                    logActivity($pdo, $user, 'INSERT', 'game', $newId, "Added game \"{$data['title']}\" to studio #{$studioId}" . ($imagePath ? ' with an image' : ''));
                    setFlash('success', "Game \"{$data['title']}\" was added.");
                    redirect("../studio.php?id={$studioId}");
                } catch (PDOException $ex) {
                    deleteImageFile($imagePath);                     // do not leave an orphan file behind
                    if (!$dup = duplicateMessage($ex)) { throw $ex; }
                    $errors[$dup[0]] = $dup[1];
                }
            }
            $_SESSION['old'] = $_POST;
            $_SESSION['errors'] = $errors;
            redirect("../studio.php?id=" . (int) ($_POST['studio_id'] ?? 0));
            break;

        case 'update_game':
            $game = getGameById($pdo, $id);
            if (!$game) {
                setFlash('error', 'That game no longer exists.');
                redirect('../index.php');
            }
            [$data, $errors] = validateGame($_POST);
            if (!$errors && !getStudioById($pdo, (int) $data['studio_id'])) {
                $errors['studio_id'] = 'That studio does not exist.';
            }
            $imagePath = null;
            if (!$errors) {
                [$imagePath, $imageError] = saveGameImage($_FILES['image'] ?? null);   // optional replacement
                if ($imageError) { $errors['image'] = $imageError; }
            }
            if (!$errors) {
                try {
                    updateGame($pdo, $id, $data, $uid);
                    if ($imagePath) {                                // new image replaces the old one
                        setGameImage($pdo, $id, $imagePath);
                        deleteImageFile($game['image_path']);
                    } elseif (!empty($_POST['remove_image']) && $game['image_path']) {
                        setGameImage($pdo, $id, null);
                        deleteImageFile($game['image_path']);
                    }
                    logActivity($pdo, $user, 'UPDATE', 'game', $id, "Updated game \"{$data['title']}\"");
                    setFlash('success', "Game #{$id} was updated.");
                    redirect("../studio.php?id=" . (int) $data['studio_id']);
                } catch (PDOException $ex) {
                    deleteImageFile($imagePath);
                    if (!$dup = duplicateMessage($ex)) { throw $ex; }
                    $errors[$dup[0]] = $dup[1];
                }
            }
            $_SESSION['old'] = $_POST;
            $_SESSION['errors'] = $errors;
            redirect("../editGame.php?id={$id}");
            break;

        case 'delete_game':                              // moves the game to the RECYCLE BIN
            $game = getGameById($pdo, $id);
            if ($game && deleteGame($pdo, $id, $uid)) {
                logActivity($pdo, $user, 'DELETE', 'game', $id, "Moved game \"{$game['title']}\" from \"{$game['studio_name']}\" to the recycle bin");
                setFlash('success', "Game \"{$game['title']}\" was moved to the recycle bin. You can restore it from there.");
                redirect("../studio.php?id=" . (int) $game['studio_id']);
            }
            setFlash('error', 'That game was already deleted.');
            redirect('../index.php');
            break;

        case 'restore_game':                             // takes the game out of the RECYCLE BIN
            $game = getDeletedGameById($pdo, $id);
            if (!$game) {
                setFlash('error', 'That game is not in the recycle bin.');
                redirect('../recycle.php');
            }
            try {
                restoreGame($pdo, $id, $uid);
                logActivity($pdo, $user, 'RESTORE', 'game', $id, "Restored game \"{$game['title']}\" to \"{$game['studio_name']}\"");
                setFlash('success', "Game \"{$game['title']}\" was restored to {$game['studio_name']}.");
                redirect("../studio.php?id=" . (int) $game['studio_id']);
            } catch (PDOException $ex) {
                if (($ex->errorInfo[1] ?? 0) !== 1062) { throw $ex; }
                setFlash('error', "Cannot restore: {$game['studio_name']} already has an active game titled \"{$game['title']}\". Rename or delete that one first.");
                redirect('../recycle.php');
            }
            break;

        default:
            setFlash('error', 'Unknown action.');
            redirect('../index.php');
    }
} catch (PDOException $ex) {
    error_log($ex->getMessage());                    // details stay in the server log
    setFlash('error', 'Something went wrong with the database. Please try again.');
    redirect('../index.php');
}
