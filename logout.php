<?php
session_start();
require_once 'config.php';

// Registrar en auditoría el cierre de sesión
if (isset($_SESSION['usuario'])) {
    $id_usuario = $_SESSION['usuario']['id_usuario'];
    $stmtAuditoria = $conn->prepare("CALL registrar_auditoria('Usuarios', 'LOGOUT', 'Cierre de sesión', :id_usuario)");
    $stmtAuditoria->execute(['id_usuario' => $id_usuario]);
}

// Eliminar todas las variables de sesión
session_unset();

// Destruir la sesión
session_destroy();

// Redirigir al login
header('Location: login.php');
exit();
?>
