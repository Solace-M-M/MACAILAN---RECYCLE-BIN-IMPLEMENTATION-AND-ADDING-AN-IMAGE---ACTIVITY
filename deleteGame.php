<?php
// deleteGame.php - confirmation before DELETING a CHILD record (it goes to the recycle bin)
require_once 'core/dbConfig.php';
require_once 'core/models.php';
require_once 'core/auth.php';
requireLogin();                              // not logged in => redirected to login.php

$id = (int) ($_GET['id'] ?? 0);
$game = getGameById($pdo, $id);
if (!$game) {
    setFlash('error', 'Game not found.');
    redirect('index.php');
}
$pageTitle = 'Delete game #' . $id;
require 'views/header.php';
?>
<section class="card">
    <h2>Move this game to the recycle bin?</h2>
    <p>You are about to delete <strong><?= e($game['title']) ?></strong>
       (<?= e($game['genre']) ?>, by <?= e($game['studio_name']) ?>). It moves to the <a href="recycle.php">recycle bin</a>,
       where your name and the time are recorded and it can be restored.</p>
    <form action="core/handleForms.php" method="post">
        <input type="hidden" name="csrf" value="<?= e(csrfToken()) ?>">
        <input type="hidden" name="action" value="delete_game">
        <input type="hidden" name="id" value="<?= $id ?>">
        <button type="submit" class="btn danger">Yes, delete (move to recycle bin)</button>
        <a href="studio.php?id=<?= (int) $game['studio_id'] ?>" class="btn ghost">Cancel</a>
    </form>
</section>
<?php require 'views/footer.php'; ?>
