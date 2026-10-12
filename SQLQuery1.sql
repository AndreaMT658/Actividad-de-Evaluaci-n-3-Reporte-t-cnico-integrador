-- ========================================================
-- 1. CREACIÓN DE LA BASE DE DATOS
-- ========================================================
CREATE DATABASE CampusCloud;
GO

USE CampusCloud;
GO

-- ========================================================
-- 2. CREACIÓN DE TABLAS (DDL) Y RELACIONES
-- ========================================================

-- Tabla Estudiantes
CREATE TABLE Estudiantes (
    IdEstudiante INT IDENTITY(1,1) PRIMARY KEY,
    Matricula VARCHAR(20) UNIQUE NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Correo VARCHAR(100) NOT NULL
);
GO

-- Tabla Servicios
CREATE TABLE Servicios (
    IdServicio INT IDENTITY(1,1) PRIMARY KEY,
    NombreServicio VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(255),
    Activo BIT DEFAULT 1
);
GO

-- Tabla Solicitudes (con Llaves Foráneas)
CREATE TABLE Solicitudes (
    IdSolicitud INT IDENTITY(1,1) PRIMARY KEY,
    IdEstudiante INT FOREIGN KEY REFERENCES Estudiantes(IdEstudiante),
    IdServicio INT FOREIGN KEY REFERENCES Servicios(IdServicio),
    FechaSolicitud DATE NOT NULL,
    Estado VARCHAR(50) NOT NULL
);
GO

-- Tabla Categorías (Creada de forma colaborativa/remota)
CREATE TABLE Categorias (
    IdCategoria INT IDENTITY(1,1) PRIMARY KEY,
    NombreCategoria VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(150)
);
GO

-- ========================================================
-- 3. INSERCIÓN DE DATOS INICIALES (DML)
-- ========================================================

-- Insertar Estudiantes
INSERT INTO Estudiantes (Matricula, Nombre, Correo) VALUES 
('TI2026001', 'Andrea Pérez', 'andrea@unitep.edu.mx'),
('TI2026002', 'Carlos Gómez', 'carlos.gomez@unitep.edu.mx'),
('TI2026003', 'María Rodríguez', 'maria.rodriguez@unitep.edu.mx'),
('TI2026004', 'Juan López', 'juan.lopez@unitep.edu.mx'),
('TI2026005', 'Sofía Martínez', 'sofia.martinez@unitep.edu.mx'),
('TI2026006', 'Luis Hernández', 'luis.hernandez@unitep.edu.mx'),
('TI2026007', 'Ana Torres', 'ana.torres@unitep.edu.mx'),
('TI2026008', 'Diego Ramírez', 'diego.ramirez@unitep.edu.mx'),
('TI2026009', 'Valeria Flores', 'valeria.flores@unitep.edu.mx');
GO

-- Insertar Servicios
INSERT INTO Servicios (NombreServicio, Descripcion, Activo) VALUES 
('Constancia de Estudios', 'Emisión de constancia oficial con calificaciones', 1),
('Credencial Escolar', 'Reposición de credencial por extravío', 1),
('Historial Académico', 'Kardex certificado de materias cursadas', 1),
('Baja Temporal', 'Trámite oficial de pausa temporal de estudios', 1),
('Constancia de Inscripción', 'Comprobante de estatus de estudiante activo', 1);
GO

-- Insertar Solicitudes
INSERT INTO Solicitudes (IdEstudiante, IdServicio, FechaSolicitud, Estado) VALUES 
(1, 1, '2026-10-01', 'Aprobado'),
(2, 3, '2026-10-02', 'Aprobado'),
(3, 2, '2026-10-02', 'Proceso');
GO

-- Insertar Categorías
INSERT INTO Categorias (NombreCategoria, Descripcion) VALUES 
('Tecnología', 'Servicios relacionados con equipos y software'),
('Escolares', 'Trámites y constancias de control escolar'),
('Administrativos', 'Gestiones de pagos y becas');
GO

-- ========================================================
-- 4. SEGURIDAD Y ROLES (DCL)
-- ========================================================

-- Crear Logins y Usuarios
CREATE LOGIN UserConsulta WITH PASSWORD = 'PasswordConsulta123!!';
CREATE USER UsuarioConsulta FOR LOGIN UserConsulta;
GO

CREATE LOGIN UserOperador WITH PASSWORD = 'PasswordOperador123!!';
CREATE USER UsuarioOperador FOR LOGIN UserOperador;
GO

CREATE LOGIN UserAdmin WITH PASSWORD = 'PasswordAdmin123!!';
CREATE USER UsuarioAdmin FOR LOGIN UserAdmin;
GO

-- Asignación de Permisos y Principio de Mínimo Privilegio
ALTER ROLE db_datareader ADD MEMBER UsuarioConsulta;
GO

ALTER ROLE db_datareader ADD MEMBER UsuarioOperador;
ALTER ROLE db_datawriter ADD MEMBER UsuarioOperador;
DENY DELETE ON DATABASE::CampusCloud TO UsuarioOperador;
GO

ALTER ROLE db_owner ADD MEMBER UserAdmin;
GO

-- ========================================================
-- 5. OPERACIONES DE CONSULTA, ACTUALIZACIÓN Y MANIPULACIÓN
-- ========================================================

-- Consulta simple (SELECT)
SELECT * FROM Estudiantes;
SELECT * FROM Servicios;
SELECT * FROM Solicitudes;
SELECT * FROM Categorias;
GO

-- Consulta avanzada con INNER JOIN
SELECT 
    s.IdSolicitud,
    e.Matricula,
    e.Nombre AS Estudiante,
    srv.NombreServicio,
    s.FechaSolicitud,
    s.Estado
FROM Solicitudes s
INNER JOIN Estudiantes e ON s.IdEstudiante = e.IdEstudiante
INNER JOIN Servicios srv ON s.IdServicio = srv.IdServicio;
GO

-- Actualización de registros (UPDATE)
UPDATE Solicitudes 
SET Estado = 'Aprobado' 
WHERE IdSolicitud = 3;
GO