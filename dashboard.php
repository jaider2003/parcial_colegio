<?php
session_start();

// Verificar que haya sesión activa
if (!isset($_SESSION['usuario'])) {
    header('Location: login.php');
    exit();
}

// Obtener el nombre completo del usuario
$nombreCompleto = $_SESSION['usuario']['nombre'] . ' ' . $_SESSION['usuario']['apellido'];
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Bienvenido</title>
    <style>
        body {
            background: linear-gradient(to right, #0072ff, #00c6ff);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            color: white;
            text-align: center;
        }
        .dashboard {
            background: rgba(0, 0, 0, 0.3);
            padding: 2rem;
            border-radius: 12px;
        }
        h1 {
            margin-bottom: 1rem;
        }
        a {
            display: inline-block;
            margin-top: 1rem;
            padding: 10px 20px;
            background-color: #00c6ff;
            color: white;
            text-decoration: none;
            border-radius: 8px;
        }
        a:hover {
            background-color: #0072ff;
        }
    </style>
</head>
<body>
    <div class="dashboard">
        <h1>¡Bienvenido, <?php echo htmlspecialchars($nombreCompleto); ?>!</h1>
        <p>Has ingresado exitosamente al sistema del Colegio.</p>
        <a href="logout.php">Cerrar Sesión</a>
    </div>
</body>
</html>
