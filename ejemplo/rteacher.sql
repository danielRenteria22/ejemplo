-- phpMyAdmin SQL Dump
-- version 4.6.5.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 04-02-2019 a las 22:56:41
-- Versión del servidor: 10.1.21-MariaDB
-- Versión de PHP: 7.1.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `rteacher`
--

DELIMITER $$
--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `calcular_dificultad` (`id_maestro_` INT) RETURNS DOUBLE NO SQL
BEGIN
declare suma int;
declare cont int;
declare cal int;
declare prom double;

#variable booleana de control
declare fin_cursor int default false; #cuando llegueos al final, cambiar a true
#consulta select (cursor)
declare cursor_calificaciones cursor for
	SELECT Dificultad FROM calificacion WHERE id_maestro = id_maestro_;
#manejador (handler) para la variable booleana
declare continue handler for not found set fin_cursor = true;

set suma = 0;
set cont = 0;

#usar cursos
open cursor_calificaciones;
#usamos un ciclo para recorrerlo
ciclo_calificaciones: loop
	#equivalente de iterate
    fetch cursor_calificaciones into cal;
    #al llegar al final se prodce la excepcion
    #not found, cambiamos la varbale fin_cursor a true
    if fin_cursor then
		leave ciclo_calificaciones;
	else 
		set suma = suma + cal;
		set cont = cont + 1;
	end if;
end loop;

set prom = suma / cont;
    
close cursor_calificaciones;
return prom;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `calcular_promedio_general` (`id_maestro_` INT) RETURNS DOUBLE NO SQL
BEGIN
declare suma int;
declare cont int;
declare cal int;
declare prom double;

#variable booleana de control
declare fin_cursor int default false; #cuando llegueos al final, cambiar a true
#consulta select (cursor)
declare cursor_calificaciones cursor for
	SELECT calificacionGeneral FROM calificacion WHERE id_maestro = id_maestro_;
#manejador (handler) para la variable booleana
declare continue handler for not found set fin_cursor = true;

set suma = 0;
set cont = 0;

#usar cursos
open cursor_calificaciones;
#usamos un ciclo para recorrerlo
ciclo_calificaciones: loop
	#equivalente de iterate
    fetch cursor_calificaciones into cal;
    #al llegar al final se prodce la excepcion
    #not found, cambiamos la varbale fin_cursor a true
    if fin_cursor then
		leave ciclo_calificaciones;
	else 
		set suma = suma + cal;
		set cont = cont + 1;
	end if;
end loop;

set prom = suma / cont;
    
close cursor_calificaciones;
return prom;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `contar_cal_bloqueadas` (`id_user` INT) RETURNS INT(11) NO SQL
BEGIN
	DECLARE cont int;
    SELECT count(*) INTO cont 
    FROM calificacion
    WHERE id_usuario = id_user AND bloqueado = 1;
    return cont;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `contar_reportes` (`id_cal` INT) RETURNS INT(11) NO SQL
BEGIN
	declare cont int;
	SELECT count(*) INTO cont 
	FROM votos
	WHERE id_calificacion = id_cal AND tipo = 'REPORTE';
	return cont;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `contar_util` (`id_cal` INT) RETURNS INT(11) NO SQL
BEGIN
	declare cont int;
	SELECT count(*) INTO cont 
	FROM votos
	WHERE id_calificacion = id_cal AND tipo = 'UTIL';
	return cont;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `porcentaje_volver_a_tomar` (`id_maestro_` INT) RETURNS DOUBLE NO SQL
BEGIN
declare suma int;
declare cont int;
declare cal int;
declare prom double;

#variable booleana de control
declare fin_cursor int default false; #cuando llegueos al final, cambiar a true
#consulta select (cursor)
declare cursor_calificaciones cursor for
	SELECT volver_a_tomar FROM calificacion WHERE id_maestro = id_maestro_;
#manejador (handler) para la variable booleana
declare continue handler for not found set fin_cursor = true;

set suma = 0;
set cont = 0;

#usar cursos
open cursor_calificaciones;
#usamos un ciclo para recorrerlo
ciclo_calificaciones: loop
	#equivalente de iterate
    fetch cursor_calificaciones into cal;
    #al llegar al final se prodce la excepcion
    #not found, cambiamos la varbale fin_cursor a true
    if fin_cursor then
		leave ciclo_calificaciones;
	else 
		set suma = suma + cal;
		set cont = cont + 1;
	end if;
end loop;

set prom = (suma / cont) * 100;
    
close cursor_calificaciones;
return prom;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `calificacion`
--

CREATE TABLE `calificacion` (
  `id_calificacion` int(11) NOT NULL,
  `id_maestro` int(11) DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `id_materias` int(11) DEFAULT NULL,
  `calificacionGeneral` int(11) DEFAULT NULL,
  `Dificultad` int(11) DEFAULT NULL,
  `calificacion_obtenida` int(11) DEFAULT NULL,
  `volver_a_tomar` tinyint(1) DEFAULT NULL,
  `comentario` text,
  `util` int(11) NOT NULL DEFAULT '0',
  `reportes` int(11) NOT NULL DEFAULT '0',
  `bloqueado` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `calificacion`
--

INSERT INTO `calificacion` (`id_calificacion`, `id_maestro`, `id_usuario`, `id_materias`, `calificacionGeneral`, `Dificultad`, `calificacion_obtenida`, `volver_a_tomar`, `comentario`, `util`, `reportes`, `bloqueado`) VALUES
(21, 39, 1, 1, 8, 6, 95, 1, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque lacus odio, lobortis sed turpis eget, rutrum sollicitudin ipsum. Sed nec est euismod, laoreet felis quis, tincidunt ex.', 0, 0, 0),
(22, 39, 1, 1, 8, 6, 95, 1, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque lacus odio, lobortis sed turpis eget, rutrum sollicitudin ipsum. Sed nec est euismod, laoreet felis quis, tincidunt ex. 2222', 0, 0, 0),
(23, 39, 1, 17, 5, 5, 70, 0, 'ergerg', 0, 0, 1),
(24, 40, 1, 61, 8, 3, 95, 1, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla ullamcorper justo vel arcu consequat facilisis. Pellentesque vitae pulvinar arcu, id luctus sem. ', 0, 0, 0),
(25, 41, 1, 17, 8, 9, 81, 0, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla ullamcorper justo vel arcu consequat facilisis. Pellentesque vitae pulvinar arcu, id luctus sem. ', 0, 0, 0),
(26, 40, 1, 55, 7, 8, 77, 1, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla ullamcorper justo vel arcu consequat facilisis. Pellentesque vitae pulvinar arcu, id luctus sem. ', 0, 0, 0),
(27, 42, 1, 61, 8, 7, 76, 0, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla ullamcorper justo vel arcu consequat facilisis. Pellentesque vitae pulvinar arcu, id luctus sem. ', 0, 0, 0),
(28, 39, 1, 11, 8, 10, 70, 0, 'This is a commnet', 0, 0, 0),
(29, 43, 1, 40, 9, 10, 94, 1, 'Es una clase difÃ­cil, hay mucho material por cubrir y ademas hay un proyecto final, pero todo el se compensa por la gran cantidad de conocimiento que obtienes al terminar el curso', 0, 0, 0),
(30, 39, 1, 40, 5, 5, 70, 1, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed posuere sem sit amet justo commodo viverra.', 0, 0, 0);

--
-- Disparadores `calificacion`
--
DELIMITER $$
CREATE TRIGGER `bloquear_usuario` AFTER UPDATE ON `calificacion` FOR EACH ROW BEGIN
	DECLARE cont int;
    DECLARE id_user int;
    
    SET id_user = NEW.id_usuario;
    SET cont = contar_cal_bloqueadas(id_user);
    
    IF cont >= 5 THEN
    	UPDATE usuario SET bloqueado = 1 WHERE id_Usuario = id_user;
    ELSE
    	UPDATE usuario SET bloqueado = 0 WHERE id_Usuario = id_user;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departamento`
--

CREATE TABLE `departamento` (
  `id_departamento` int(11) NOT NULL,
  `Nombre` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `departamento`
--

INSERT INTO `departamento` (`id_departamento`, `Nombre`) VALUES
(1, 'Matemáticas '),
(2, 'Química'),
(3, 'Programación '),
(4, 'Arquitectura'),
(5, 'Fisica');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `descripciones_rapidas`
--

CREATE TABLE `descripciones_rapidas` (
  `id_descripciones_rapidas` int(11) NOT NULL,
  `Descripcion` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `descripciones_rapidas`
--

INSERT INTO `descripciones_rapidas` (`id_descripciones_rapidas`, `Descripcion`) VALUES
(1, 'Asistencia obligatoria '),
(2, 'Demasiada tarea'),
(3, 'Falta demasiado'),
(5, 'Facilita el aprendizaje'),
(6, 'Examenes imposibles'),
(7, '100 Facil'),
(8, 'Encarga proyecto final'),
(9, 'Con vocacion de maestro'),
(10, 'EnseÃ±anza estructurada'),
(11, 'De chase');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `descripcion_calificacion`
--

CREATE TABLE `descripcion_calificacion` (
  `id_descripcion_calificacion` int(11) NOT NULL,
  `id_calificacion` int(11) DEFAULT NULL,
  `id_descripcioon` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `descripcion_calificacion`
--

INSERT INTO `descripcion_calificacion` (`id_descripcion_calificacion`, `id_calificacion`, `id_descripcioon`) VALUES
(13, 21, 1),
(14, 21, 5),
(15, 21, 10),
(16, 22, 1),
(17, 22, 5),
(18, 22, 10),
(19, 23, 3),
(20, 23, 6),
(21, 23, 7),
(22, 24, 7),
(23, 24, 9),
(24, 24, 11),
(25, 25, 3),
(26, 25, 8),
(27, 26, 1),
(28, 26, 7),
(29, 26, 11),
(30, 27, 3),
(31, 27, 7),
(32, 27, 8),
(33, 28, 1),
(34, 28, 2),
(35, 28, 11),
(36, 29, 5),
(37, 29, 8),
(38, 29, 10),
(39, 29, 11),
(40, 30, 7),
(41, 30, 8);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `escuela`
--

CREATE TABLE `escuela` (
  `id_Escuela` int(11) NOT NULL,
  `Nombre` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `escuela`
--

INSERT INTO `escuela` (`id_Escuela`, `Nombre`) VALUES
(1, 'Instituto Tecnológico de Chihuahua II '),
(2, 'Universidad Autónoma de Chihuahua'),
(3, 'Universidad La Salle'),
(8, 'Universidad de Durago');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `maestro`
--

CREATE TABLE `maestro` (
  `id_maestro` int(11) NOT NULL,
  `id_Escuela` int(11) NOT NULL,
  `Nombre` varchar(45) DEFAULT NULL,
  `Apellidos` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `maestro`
--

INSERT INTO `maestro` (`id_maestro`, `id_Escuela`, `Nombre`, `Apellidos`) VALUES
(39, 1, 'Roberto', 'Reyes Montesinos'),
(40, 1, 'Juan Antonio', 'Alcalde Herreo'),
(41, 1, 'Ramon', 'Pacheco Rosell'),
(42, 1, 'Raul', 'Flor Sesma'),
(43, 1, 'Ruben', 'Hernandez');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `materias`
--

CREATE TABLE `materias` (
  `id_materias` int(11) NOT NULL,
  `id_departamento` int(11) DEFAULT NULL,
  `Nombre` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `materias`
--

INSERT INTO `materias` (`id_materias`, `id_departamento`, `Nombre`) VALUES
(1, 3, 'Fundamentos de programación'),
(2, 1, 'Álgebra lineal'),
(3, 1, 'Calculo diferencial'),
(4, 1, 'Calculo Integral'),
(7, 3, 'Programa Orientada a Objetos'),
(8, 3, 'Tópicos Avanzados de Programación'),
(9, 4, 'Planos 1'),
(10, 4, 'Planos 2'),
(11, 1, 'Ecuaciones Diferenciales'),
(12, 1, 'Pre-calculo'),
(13, 2, 'Quimica Basica'),
(14, 2, 'Quimica Organica'),
(15, 2, 'Quimica Inorganica'),
(16, 2, 'Quimica Analitica'),
(17, 2, 'Bioquimica'),
(18, 2, 'Laboratorio de Quimica '),
(19, 2, 'Ingenieria Quimica'),
(20, 2, 'Quimica Agricola'),
(21, 2, 'Quimica Fisica'),
(22, 2, 'Espectroscopia'),
(23, 2, 'GeoquÃ­mica'),
(24, 2, 'ElectroquÃ­mica'),
(25, 2, 'QuÃ­mica organometalica'),
(26, 2, 'QuÃ­mica bioinorgÃ¡nica'),
(27, 2, 'QuÃ­mica de heterociclos'),
(28, 1, 'Calculo Vectorial'),
(29, 1, 'Geometria'),
(30, 1, 'Algebra basica'),
(31, 1, 'Metodos numericos'),
(32, 1, 'Probabilidad y estadistica'),
(33, 1, 'Analisis Matematico'),
(34, 1, 'Geometria Diferencial'),
(35, 1, 'Topologia'),
(36, 1, 'Ecuaciones Algebraicas'),
(37, 1, 'Analisis Complejo'),
(38, 1, 'Calculo numerico'),
(39, 3, 'Estructura de datos'),
(40, 3, 'Bases de datos'),
(41, 3, 'Programacion Web'),
(42, 3, 'Inteligencia Artificial'),
(43, 3, 'Lenguajes y automatas'),
(44, 3, 'Ingenieria de Software'),
(45, 3, 'Redes'),
(47, 3, 'Programacion Movil'),
(48, 3, 'Sistemas Embebidos'),
(49, 3, 'Sistemas operativos'),
(50, 3, 'Graficacion'),
(51, 3, 'Programacion Funcional'),
(52, 5, 'Fisica Clasica'),
(53, 5, 'Termodinamica'),
(54, 5, 'Mecanica'),
(55, 5, 'Estatica'),
(56, 5, 'Electromagnetismo'),
(57, 5, 'Laboratorio'),
(58, 5, 'Optica'),
(59, 5, 'Mecanica Cuantica'),
(60, 5, 'Fisica Moderna'),
(61, 5, 'Circuitos Electricos');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `nivel_usuario`
--

CREATE TABLE `nivel_usuario` (
  `id_nivelUsuario` int(11) NOT NULL,
  `nombre` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `nivel_usuario`
--

INSERT INTO `nivel_usuario` (`id_nivelUsuario`, `nombre`) VALUES
(1, 'Administrador'),
(2, 'Moderador'),
(3, 'Usuario');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id_Usuario` int(11) NOT NULL,
  `username` varchar(45) DEFAULT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `apellido` varchar(45) DEFAULT NULL,
  `id_escuela` int(11) DEFAULT NULL,
  `id_nivelUsuario` int(11) DEFAULT NULL,
  `bloqueado` tinyint(1) NOT NULL DEFAULT '0',
  `password` varchar(45) NOT NULL DEFAULT '123'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id_Usuario`, `username`, `nombre`, `apellido`, `id_escuela`, `id_nivelUsuario`, `bloqueado`, `password`) VALUES
(1, 'CodeSlayer', 'DanieL', 'Rentería', 1, 3, 0, '123'),
(5, 'RF03', 'Rafa', 'Palma', 2, 3, 0, '123'),
(7, 'admin', NULL, NULL, NULL, 1, 0, '123'),
(8, 'Temo', 'Temo', 'Vare', 1, 3, 0, '123'),
(10, 'Coach', 'Roberto', 'Espino', 1, 3, 0, '123'),
(11, 'Snorlax', 'David', 'Torres', 1, 3, 0, '123'),
(12, 'Locoman', 'Saul', 'El Loco', 1, 3, 0, '123');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `votos`
--

CREATE TABLE `votos` (
  `id_calificacion` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `tipo` enum('UTIL','REPORTE') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `votos`
--

INSERT INTO `votos` (`id_calificacion`, `id_usuario`, `tipo`) VALUES
(23, 1, 'REPORTE'),
(23, 8, 'REPORTE'),
(23, 10, 'REPORTE'),
(23, 11, 'REPORTE'),
(23, 12, 'REPORTE');

--
-- Disparadores `votos`
--
DELIMITER $$
CREATE TRIGGER `bloquear_comentario` AFTER INSERT ON `votos` FOR EACH ROW BEGIN
	DECLARE cont int;
    DECLARE id_cal int;
    
    SET id_cal = NEW.id_calificacion;
    SET cont = contar_reportes(id_cal);
    
    IF cont >= 5 THEN
    	UPDATE calificacion SET bloqueado = 1 WHERE id_calificacion = id_cal;
    ELSE
    	UPDATE calificacion SET bloqueado = 0 WHERE id_calificacion = id_cal;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `desbloquear_comentario` AFTER DELETE ON `votos` FOR EACH ROW BEGIN
	DECLARE cont int;
    DECLARE id_cal int;
    
    SET id_cal = OLD.id_calificacion;
    SET cont = contar_reportes(id_cal);
    
    IF cont < 5 THEN
    	UPDATE calificacion SET bloqueado = 0 WHERE id_calificacion = id_cal;
    END IF;
END
$$
DELIMITER ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `calificacion`
--
ALTER TABLE `calificacion`
  ADD PRIMARY KEY (`id_calificacion`),
  ADD KEY `id_maestro_idx` (`id_maestro`),
  ADD KEY `id_usuario_idx` (`id_usuario`),
  ADD KEY `id_materia_idx` (`id_materias`);

--
-- Indices de la tabla `departamento`
--
ALTER TABLE `departamento`
  ADD PRIMARY KEY (`id_departamento`);

--
-- Indices de la tabla `descripciones_rapidas`
--
ALTER TABLE `descripciones_rapidas`
  ADD PRIMARY KEY (`id_descripciones_rapidas`);

--
-- Indices de la tabla `descripcion_calificacion`
--
ALTER TABLE `descripcion_calificacion`
  ADD PRIMARY KEY (`id_descripcion_calificacion`),
  ADD KEY `id_calificacion_idx` (`id_calificacion`),
  ADD KEY `id_descripcion_idx` (`id_descripcioon`);

--
-- Indices de la tabla `escuela`
--
ALTER TABLE `escuela`
  ADD PRIMARY KEY (`id_Escuela`);

--
-- Indices de la tabla `maestro`
--
ALTER TABLE `maestro`
  ADD PRIMARY KEY (`id_maestro`),
  ADD KEY `id_maestro_idx` (`id_Escuela`);

--
-- Indices de la tabla `materias`
--
ALTER TABLE `materias`
  ADD PRIMARY KEY (`id_materias`),
  ADD KEY `id_departamento_idx` (`id_departamento`);

--
-- Indices de la tabla `nivel_usuario`
--
ALTER TABLE `nivel_usuario`
  ADD PRIMARY KEY (`id_nivelUsuario`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_Usuario`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `id_Escuela_idx` (`id_escuela`),
  ADD KEY `id_nivelUsuario_idx` (`id_nivelUsuario`);

--
-- Indices de la tabla `votos`
--
ALTER TABLE `votos`
  ADD PRIMARY KEY (`id_calificacion`,`id_usuario`),
  ADD KEY `fk_usuario` (`id_usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `calificacion`
--
ALTER TABLE `calificacion`
  MODIFY `id_calificacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;
--
-- AUTO_INCREMENT de la tabla `departamento`
--
ALTER TABLE `departamento`
  MODIFY `id_departamento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT de la tabla `descripciones_rapidas`
--
ALTER TABLE `descripciones_rapidas`
  MODIFY `id_descripciones_rapidas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT de la tabla `descripcion_calificacion`
--
ALTER TABLE `descripcion_calificacion`
  MODIFY `id_descripcion_calificacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;
--
-- AUTO_INCREMENT de la tabla `escuela`
--
ALTER TABLE `escuela`
  MODIFY `id_Escuela` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT de la tabla `maestro`
--
ALTER TABLE `maestro`
  MODIFY `id_maestro` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;
--
-- AUTO_INCREMENT de la tabla `materias`
--
ALTER TABLE `materias`
  MODIFY `id_materias` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;
--
-- AUTO_INCREMENT de la tabla `nivel_usuario`
--
ALTER TABLE `nivel_usuario`
  MODIFY `id_nivelUsuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_Usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `calificacion`
--
ALTER TABLE `calificacion`
  ADD CONSTRAINT `calificacion_ibfk_1` FOREIGN KEY (`id_maestro`) REFERENCES `maestro` (`id_maestro`),
  ADD CONSTRAINT `id_materia` FOREIGN KEY (`id_materias`) REFERENCES `materias` (`id_materias`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `id_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`);

--
-- Filtros para la tabla `descripcion_calificacion`
--
ALTER TABLE `descripcion_calificacion`
  ADD CONSTRAINT `id_calificacion` FOREIGN KEY (`id_calificacion`) REFERENCES `calificacion` (`id_calificacion`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `id_descripcion` FOREIGN KEY (`id_descripcioon`) REFERENCES `descripciones_rapidas` (`id_descripciones_rapidas`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `maestro`
--
ALTER TABLE `maestro`
  ADD CONSTRAINT `id_maestro` FOREIGN KEY (`id_Escuela`) REFERENCES `escuela` (`id_Escuela`);

--
-- Filtros para la tabla `materias`
--
ALTER TABLE `materias`
  ADD CONSTRAINT `id_departamento` FOREIGN KEY (`id_departamento`) REFERENCES `departamento` (`id_departamento`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `id_Escuela` FOREIGN KEY (`id_escuela`) REFERENCES `escuela` (`id_Escuela`),
  ADD CONSTRAINT `id_nivelUsuario` FOREIGN KEY (`id_nivelUsuario`) REFERENCES `nivel_usuario` (`id_nivelUsuario`);

--
-- Filtros para la tabla `votos`
--
ALTER TABLE `votos`
  ADD CONSTRAINT `fk_calificacion` FOREIGN KEY (`id_calificacion`) REFERENCES `calificacion` (`id_calificacion`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_Usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
