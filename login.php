<?php
session_start();
require_once 'config.php';

$mensaje = '';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $correo = $_POST['correo'] ?? '';
    $contrasena = $_POST['contrasena'] ?? '';

    if (!empty($correo) && !empty($contrasena)) {
        $stmt = $conn->prepare("SELECT * FROM Usuarios WHERE correo = :correo LIMIT 1");
        $stmt->execute(['correo' => $correo]);
        $usuario = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($usuario && password_verify($contrasena, $usuario['contrasena'])) {
            if ($usuario['estado'] === 'activo') {
                $_SESSION['usuario'] = $usuario;

                // Registrar en auditoria
                $stmtAuditoria = $conn->prepare("CALL registrar_auditoria('Usuarios', 'LOGIN', 'Inicio de sesión exitoso', :id_usuario)");
                $stmtAuditoria->execute(['id_usuario' => $usuario['id_usuario']]);

                header('Location: dashboard.php');
                exit();
            } else {
                $mensaje = "Tu cuenta está inactiva o bloqueada.";
            }
        } else {
            // Intento fallido
            $stmtAuditoria = $conn->prepare("CALL registrar_auditoria('Usuarios', 'LOGIN', 'Intento de inicio de sesión fallido', NULL)");
            $stmtAuditoria->execute();
            $mensaje = "Correo o contraseña incorrectos.";
        }
    } else {
        $mensaje = "Por favor completa todos los campos.";
    }
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Login Colegio</title>
    <style>
        body {
            background: linear-gradient(to right, #0072ff, #00c6ff);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }
        .login-container {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0px 4px 20px rgba(0, 0, 0, 0.2);
            width: 300px;
            text-align: center;
        }
        h2 {
            margin-bottom: 1.5rem;
            color: #0072ff;
        }
        input[type="email"], input[type="password"] {
            width: 90%;
            padding: 10px;
            margin-bottom: 1rem;
            border: 1px solid #ccc;
            border-radius: 8px;
        }
        button {
            background-color: #0072ff;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            width: 100%;
            font-size: 1rem;
        }
        button:hover {
            background-color: #005fcc;
        }
        .mensaje {
            color: red;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Ingreso Colegio</h2>
        <?php if (!empty($mensaje)): ?>
            <div class="mensaje"><?php echo htmlspecialchars($mensaje); ?></div>
        <?php endif; ?>
        <form method="POST" action="">
            <input type="email" name="correo" placeholder="Correo electrónico" required><br>
            <input type="password" name="contrasena" placeholder="Contraseña" required><br>
            <button type="submit">Ingresar</button>
        </form>
    </div>
</body>
</html>
