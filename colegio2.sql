-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 28-04-2025 a las 21:49:11
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `colegio2`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`` PROCEDURE `bloquear_usuario` (IN `p_id_usuario` INT, IN `p_razon` TEXT)   BEGIN
    INSERT INTO UsuariosBloqueados (id_usuario, razon_bloqueo) VALUES (p_id_usuario, p_razon);
    UPDATE Usuarios SET estado = 'inactivo' WHERE id_usuario = p_id_usuario;
END$$

CREATE DEFINER=`` PROCEDURE `registrar_auditoria` (IN `p_modelo` VARCHAR(50), IN `p_operacion` ENUM('INSERT','UPDATE','DELETE'), IN `p_descripcion` TEXT, IN `p_usuario` INT)   BEGIN
    INSERT INTO Auditoria (modelo_afectado, operacion, descripcion, usuario_realizo_operacion)
    VALUES (p_modelo, p_operacion, p_descripcion, p_usuario);
END$$

--
-- Funciones
--
CREATE DEFINER=`` FUNCTION `obtener_nombre_completo` (`p_id_usuario` INT) RETURNS VARCHAR(120) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE nombre_completo VARCHAR(120);
    SELECT CONCAT(nombre, ' ', apellido) INTO nombre_completo
    FROM Usuarios
    WHERE id_usuario = p_id_usuario;
    RETURN nombre_completo;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `areasinstitucion`
--

CREATE TABLE `areasinstitucion` (
  `id_area` int(11) NOT NULL,
  `nombre_area` varchar(100) DEFAULT NULL,
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `areasinstitucion`
--

INSERT INTO `areasinstitucion` (`id_area`, `nombre_area`, `descripcion`) VALUES
(1, 'Biblioteca', 'Área de biblioteca de la institución'),
(2, 'Laboratorio de Computo', 'Área de laboratorios de computadoras');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria`
--

CREATE TABLE `auditoria` (
  `id_auditoria` int(11) NOT NULL,
  `modelo_afectado` varchar(50) DEFAULT NULL,
  `operacion` enum('INSERT','UPDATE','DELETE') DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha_operacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `usuario_realizo_operacion` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cursos`
--

CREATE TABLE `cursos` (
  `id_curso` int(11) NOT NULL,
  `nombre_curso` varchar(100) DEFAULT NULL,
  `id_programa` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cursos`
--

INSERT INTO `cursos` (`id_curso`, `nombre_curso`, `id_programa`) VALUES
(1, 'Matemáticas I', 1),
(2, 'Introducción a la Administración', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `docentecurso`
--

CREATE TABLE `docentecurso` (
  `id_docente_curso` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `id_curso` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `docentecurso`
--

INSERT INTO `docentecurso` (`id_docente_curso`, `id_usuario`, `id_curso`) VALUES
(1, 2, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `equipostecnologicos`
--

CREATE TABLE `equipostecnologicos` (
  `id_equipo` int(11) NOT NULL,
  `nombre_equipo` varchar(100) DEFAULT NULL,
  `marca` varchar(50) DEFAULT NULL,
  `modelo` varchar(50) DEFAULT NULL,
  `numero_serie` varchar(50) DEFAULT NULL,
  `id_area` int(11) DEFAULT NULL,
  `estado` enum('activo','inactivo') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `equipostecnologicos`
--

INSERT INTO `equipostecnologicos` (`id_equipo`, `nombre_equipo`, `marca`, `modelo`, `numero_serie`, `id_area`, `estado`) VALUES
(1, 'Computadora HP', 'HP', 'Elitebook', 'SN123456', 2, 'activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `eventos`
--

CREATE TABLE `eventos` (
  `id_evento` int(11) NOT NULL,
  `titulo_evento` varchar(100) DEFAULT NULL,
  `descripcion_evento` text DEFAULT NULL,
  `fecha_evento` date DEFAULT NULL,
  `lugar_evento` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `eventos`
--

INSERT INTO `eventos` (`id_evento`, `titulo_evento`, `descripcion_evento`, `fecha_evento`, `lugar_evento`) VALUES
(1, 'Congreso de Tecnología', 'Congreso anual de tecnología', '2025-06-20', 'Auditorio Principal');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inscripciones`
--

CREATE TABLE `inscripciones` (
  `id_inscripcion` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `id_curso` int(11) DEFAULT NULL,
  `fecha_inscripcion` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `inscripciones`
--

INSERT INTO `inscripciones` (`id_inscripcion`, `id_usuario`, `id_curso`, `fecha_inscripcion`) VALUES
(1, 1, 1, '2025-04-01');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notas`
--

CREATE TABLE `notas` (
  `id_nota` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `id_curso` int(11) DEFAULT NULL,
  `nota` decimal(5,2) DEFAULT NULL,
  `periodo` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `notas`
--

INSERT INTO `notas` (`id_nota`, `id_usuario`, `id_curso`, `nota`, `periodo`) VALUES
(1, 1, 1, 85.50, '2025-1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personaladministrativo`
--

CREATE TABLE `personaladministrativo` (
  `id_personal` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `cargo` varchar(50) DEFAULT NULL,
  `dependencia` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `personaladministrativo`
--

INSERT INTO `personaladministrativo` (`id_personal`, `id_usuario`, `cargo`, `dependencia`) VALUES
(1, 3, 'Secretario', 'Rectoría');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `programas`
--

CREATE TABLE `programas` (
  `id_programa` int(11) NOT NULL,
  `nombre_programa` varchar(100) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `nivel` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `programas`
--

INSERT INTO `programas` (`id_programa`, `nombre_programa`, `descripcion`, `nivel`) VALUES
(1, 'Ingeniería de Sistemas', 'Programa de ingeniería informática', 'Universitario'),
(2, 'Administración de Empresas', 'Programa de administración', 'Universitario');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellido` varchar(50) DEFAULT NULL,
  `documento_identidad` varchar(20) DEFAULT NULL,
  `tipo_usuario` enum('estudiante','docente','administrativo') DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` varchar(100) DEFAULT NULL,
  `estado` enum('activo','inactivo') DEFAULT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `apellido`, `documento_identidad`, `tipo_usuario`, `email`, `telefono`, `direccion`, `estado`, `fecha_registro`) VALUES
(1, 'Juan', 'Pérez', '12345678', 'estudiante', 'juan@example.com', '123456789', 'Calle 1', 'activo', '2025-04-28 19:48:24'),
(2, 'Ana', 'García', '87654321', 'docente', 'ana@example.com', '987654321', 'Calle 2', 'activo', '2025-04-28 19:48:24'),
(3, 'Luis', 'Martínez', '56781234', 'administrativo', 'luis@example.com', '555666777', 'Calle 3', 'activo', '2025-04-28 19:48:24');

--
-- Disparadores `usuarios`
--
DELIMITER $$
CREATE TRIGGER `trg_auditoria_update_usuario` BEFORE UPDATE ON `usuarios` FOR EACH ROW BEGIN
    CALL registrar_auditoria('Usuarios', 'UPDATE', CONCAT('Actualización de usuario ID ', OLD.id_usuario), OLD.id_usuario);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuariosbloqueados`
--

CREATE TABLE `usuariosbloqueados` (
  `id_bloqueo` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `razon_bloqueo` text DEFAULT NULL,
  `fecha_bloqueo` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_auditoria`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_auditoria` (
`id_auditoria` int(11)
,`modelo_afectado` varchar(50)
,`operacion` enum('INSERT','UPDATE','DELETE')
,`descripcion` text
,`fecha_operacion` timestamp
,`usuario_realizo_operacion` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_equipos_por_area`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_equipos_por_area` (
`nombre_equipo` varchar(100)
,`marca` varchar(50)
,`modelo` varchar(50)
,`nombre_area` varchar(100)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_estudiantes_activos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_estudiantes_activos` (
`id_usuario` int(11)
,`nombre` varchar(50)
,`apellido` varchar(50)
,`documento_identidad` varchar(20)
,`tipo_usuario` enum('estudiante','docente','administrativo')
,`email` varchar(100)
,`telefono` varchar(20)
,`direccion` varchar(100)
,`estado` enum('activo','inactivo')
,`fecha_registro` timestamp
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_inscripciones`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_inscripciones` (
`id_inscripcion` int(11)
,`nombre` varchar(50)
,`apellido` varchar(50)
,`nombre_curso` varchar(100)
,`fecha_inscripcion` date
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_usuarios_bloqueados`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_usuarios_bloqueados` (
`id_bloqueo` int(11)
,`nombre` varchar(50)
,`apellido` varchar(50)
,`razon_bloqueo` text
,`fecha_bloqueo` timestamp
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_auditoria`
--
DROP TABLE IF EXISTS `vista_auditoria`;

CREATE ALGORITHM=UNDEFINED DEFINER=`` SQL SECURITY DEFINER VIEW `vista_auditoria`  AS SELECT `auditoria`.`id_auditoria` AS `id_auditoria`, `auditoria`.`modelo_afectado` AS `modelo_afectado`, `auditoria`.`operacion` AS `operacion`, `auditoria`.`descripcion` AS `descripcion`, `auditoria`.`fecha_operacion` AS `fecha_operacion`, `auditoria`.`usuario_realizo_operacion` AS `usuario_realizo_operacion` FROM `auditoria` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_equipos_por_area`
--
DROP TABLE IF EXISTS `vista_equipos_por_area`;

CREATE ALGORITHM=UNDEFINED DEFINER=`` SQL SECURITY DEFINER VIEW `vista_equipos_por_area`  AS SELECT `e`.`nombre_equipo` AS `nombre_equipo`, `e`.`marca` AS `marca`, `e`.`modelo` AS `modelo`, `a`.`nombre_area` AS `nombre_area` FROM (`equipostecnologicos` `e` join `areasinstitucion` `a` on(`e`.`id_area` = `a`.`id_area`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_estudiantes_activos`
--
DROP TABLE IF EXISTS `vista_estudiantes_activos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`` SQL SECURITY DEFINER VIEW `vista_estudiantes_activos`  AS SELECT `usuarios`.`id_usuario` AS `id_usuario`, `usuarios`.`nombre` AS `nombre`, `usuarios`.`apellido` AS `apellido`, `usuarios`.`documento_identidad` AS `documento_identidad`, `usuarios`.`tipo_usuario` AS `tipo_usuario`, `usuarios`.`email` AS `email`, `usuarios`.`telefono` AS `telefono`, `usuarios`.`direccion` AS `direccion`, `usuarios`.`estado` AS `estado`, `usuarios`.`fecha_registro` AS `fecha_registro` FROM `usuarios` WHERE `usuarios`.`tipo_usuario` = 'estudiante' AND `usuarios`.`estado` = 'activo' ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_inscripciones`
--
DROP TABLE IF EXISTS `vista_inscripciones`;

CREATE ALGORITHM=UNDEFINED DEFINER=`` SQL SECURITY DEFINER VIEW `vista_inscripciones`  AS SELECT `i`.`id_inscripcion` AS `id_inscripcion`, `u`.`nombre` AS `nombre`, `u`.`apellido` AS `apellido`, `c`.`nombre_curso` AS `nombre_curso`, `i`.`fecha_inscripcion` AS `fecha_inscripcion` FROM ((`inscripciones` `i` join `usuarios` `u` on(`i`.`id_usuario` = `u`.`id_usuario`)) join `cursos` `c` on(`i`.`id_curso` = `c`.`id_curso`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_usuarios_bloqueados`
--
DROP TABLE IF EXISTS `vista_usuarios_bloqueados`;

CREATE ALGORITHM=UNDEFINED DEFINER=`` SQL SECURITY DEFINER VIEW `vista_usuarios_bloqueados`  AS SELECT `ub`.`id_bloqueo` AS `id_bloqueo`, `u`.`nombre` AS `nombre`, `u`.`apellido` AS `apellido`, `ub`.`razon_bloqueo` AS `razon_bloqueo`, `ub`.`fecha_bloqueo` AS `fecha_bloqueo` FROM (`usuariosbloqueados` `ub` join `usuarios` `u` on(`ub`.`id_usuario` = `u`.`id_usuario`)) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `areasinstitucion`
--
ALTER TABLE `areasinstitucion`
  ADD PRIMARY KEY (`id_area`);

--
-- Indices de la tabla `auditoria`
--
ALTER TABLE `auditoria`
  ADD PRIMARY KEY (`id_auditoria`),
  ADD KEY `usuario_realizo_operacion` (`usuario_realizo_operacion`);

--
-- Indices de la tabla `cursos`
--
ALTER TABLE `cursos`
  ADD PRIMARY KEY (`id_curso`),
  ADD KEY `id_programa` (`id_programa`);

--
-- Indices de la tabla `docentecurso`
--
ALTER TABLE `docentecurso`
  ADD PRIMARY KEY (`id_docente_curso`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_curso` (`id_curso`);

--
-- Indices de la tabla `equipostecnologicos`
--
ALTER TABLE `equipostecnologicos`
  ADD PRIMARY KEY (`id_equipo`),
  ADD KEY `id_area` (`id_area`);

--
-- Indices de la tabla `eventos`
--
ALTER TABLE `eventos`
  ADD PRIMARY KEY (`id_evento`);

--
-- Indices de la tabla `inscripciones`
--
ALTER TABLE `inscripciones`
  ADD PRIMARY KEY (`id_inscripcion`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_curso` (`id_curso`);

--
-- Indices de la tabla `notas`
--
ALTER TABLE `notas`
  ADD PRIMARY KEY (`id_nota`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_curso` (`id_curso`);

--
-- Indices de la tabla `personaladministrativo`
--
ALTER TABLE `personaladministrativo`
  ADD PRIMARY KEY (`id_personal`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `programas`
--
ALTER TABLE `programas`
  ADD PRIMARY KEY (`id_programa`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`);

--
-- Indices de la tabla `usuariosbloqueados`
--
ALTER TABLE `usuariosbloqueados`
  ADD PRIMARY KEY (`id_bloqueo`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `areasinstitucion`
--
ALTER TABLE `areasinstitucion`
  MODIFY `id_area` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `auditoria`
--
ALTER TABLE `auditoria`
  MODIFY `id_auditoria` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cursos`
--
ALTER TABLE `cursos`
  MODIFY `id_curso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `docentecurso`
--
ALTER TABLE `docentecurso`
  MODIFY `id_docente_curso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `equipostecnologicos`
--
ALTER TABLE `equipostecnologicos`
  MODIFY `id_equipo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `eventos`
--
ALTER TABLE `eventos`
  MODIFY `id_evento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `inscripciones`
--
ALTER TABLE `inscripciones`
  MODIFY `id_inscripcion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `notas`
--
ALTER TABLE `notas`
  MODIFY `id_nota` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `personaladministrativo`
--
ALTER TABLE `personaladministrativo`
  MODIFY `id_personal` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `programas`
--
ALTER TABLE `programas`
  MODIFY `id_programa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuariosbloqueados`
--
ALTER TABLE `usuariosbloqueados`
  MODIFY `id_bloqueo` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `auditoria`
--
ALTER TABLE `auditoria`
  ADD CONSTRAINT `auditoria_ibfk_1` FOREIGN KEY (`usuario_realizo_operacion`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `cursos`
--
ALTER TABLE `cursos`
  ADD CONSTRAINT `cursos_ibfk_1` FOREIGN KEY (`id_programa`) REFERENCES `programas` (`id_programa`);

--
-- Filtros para la tabla `docentecurso`
--
ALTER TABLE `docentecurso`
  ADD CONSTRAINT `docentecurso_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`),
  ADD CONSTRAINT `docentecurso_ibfk_2` FOREIGN KEY (`id_curso`) REFERENCES `cursos` (`id_curso`);

--
-- Filtros para la tabla `equipostecnologicos`
--
ALTER TABLE `equipostecnologicos`
  ADD CONSTRAINT `equipostecnologicos_ibfk_1` FOREIGN KEY (`id_area`) REFERENCES `areasinstitucion` (`id_area`);

--
-- Filtros para la tabla `inscripciones`
--
ALTER TABLE `inscripciones`
  ADD CONSTRAINT `inscripciones_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`),
  ADD CONSTRAINT `inscripciones_ibfk_2` FOREIGN KEY (`id_curso`) REFERENCES `cursos` (`id_curso`);

--
-- Filtros para la tabla `notas`
--
ALTER TABLE `notas`
  ADD CONSTRAINT `notas_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`),
  ADD CONSTRAINT `notas_ibfk_2` FOREIGN KEY (`id_curso`) REFERENCES `cursos` (`id_curso`);

--
-- Filtros para la tabla `personaladministrativo`
--
ALTER TABLE `personaladministrativo`
  ADD CONSTRAINT `personaladministrativo_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `usuariosbloqueados`
--
ALTER TABLE `usuariosbloqueados`
  ADD CONSTRAINT `usuariosbloqueados_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
