<?php
// recycle.php - RECYCLE BIN: games that were deleted, who deleted them, when, and a Restore button
require_once 'core/dbConfig.php';
require_once 'core/models.php';
require_once 'core/auth.php';
requireLogin();                              // not logged in => redirected to login.php

$deleted = getDeletedGames($pdo);            // every game with deleted_at filled in

$pageTitle = 'Recycle bin';
require 'views/header.php';
?>
<section class="card">
    <h2>Recycle bin (<?= count($deleted) ?>)</h2>
    <p class="muted">Deleted games are kept here with the user who deleted them and when. Restore puts a game back in its studio.</p>
    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>ID</th><th>Image</th><th>Title</th><th>Studio</th><th>Genre</th><th>Platform</th>
                    <th>Deleted by</th><th>Deleted at</th><th class="actions">Actions</th>
                </tr>
            </thead>
            <tbody>
            <?php if (!$deleted): ?>
                <tr><td colspan="9" class="empty">The recycle bin is empty.</td></tr>
            <?php endif; ?>
            <?php foreach ($deleted as $g): ?>
                <tr>
                    <td><?= (int) $g['game_id'] ?></td>
                    <td><?php if ($g['image_path']): ?><img class="thumb" src="<?= e($g['image_path']) ?>" alt="Image of <?= e($g['title']) ?>"><?php else: ?><span class="thumb none">No image</span><?php endif; ?></td>
                    <td><?= e($g['title']) ?></td>
                    <td><a href="studio.php?id=<?= (int) $g['studio_id'] ?>"><?= e($g['studio_name']) ?></a></td>
                    <td><?= e($g['genre']) ?></td>
                    <td><?= e($g['platform']) ?></td>
                    <td class="who"><strong><?= e($g['deleted_by_name'] ?? 'Unknown user') ?></strong></td>
                    <td class="who"><?= e(date('M j, Y', strtotime($g['deleted_at']))) ?><small><?= e(date('g:i:s A', strtotime($g['deleted_at']))) ?></small></td>
                    <td class="actions">
                        <form action="core/handleForms.php" method="post" class="inline">
                            <input type="hidden" name="csrf" value="<?= e(csrfToken()) ?>">
                            <input type="hidden" name="action" value="restore_game">
                            <input type="hidden" name="id" value="<?= (int) $g['game_id'] ?>">
                            <button type="submit" class="btn small primary">Restore</button>
                        </form>
                    </td>
                </tr>
            <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</section>
<?php require 'views/footer.php'; ?>
