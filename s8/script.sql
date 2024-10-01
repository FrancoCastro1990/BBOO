-- Conectarse como usuario SYSTEM
CONNECT SYSTEM/oracle;

-- Crear un nuevo usuario para la aplicación
CREATE USER ind_user IDENTIFIED BY ind_password;
GRANT CONNECT, RESOURCE, CREATE VIEW TO ind_user;
ALTER USER ind_user QUOTA UNLIMITED ON USERS;

-- Conectarse como el nuevo usuario
CONNECT ind_user/ind_password;

-- Eliminar objetos existentes si es necesario
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Costos';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Personal';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE EscuelaDeportiva';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE TipoEscuela';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE seq_tipo_escuela';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -2289 THEN
         RAISE;
      END IF;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE seq_escuela_deportiva';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -2289 THEN
         RAISE;
      END IF;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE seq_personal';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -2289 THEN
         RAISE;
      END IF;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE seq_costos';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -2289 THEN
         RAISE;
      END IF;
END;
/

-- Crear secuencias
CREATE SEQUENCE seq_tipo_escuela START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_escuela_deportiva START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_personal START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_costos START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- Crear tablas
CREATE TABLE TipoEscuela (
    id_tipo_escuela NUMBER PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    descripcion VARCHAR2(255)
);

CREATE TABLE EscuelaDeportiva (
    id_escuela NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    direccion VARCHAR2(255) NOT NULL,
    telefono VARCHAR2(20),
    email VARCHAR2(100),
    id_tipo_escuela NUMBER,
    CONSTRAINT fk_tipo_escuela FOREIGN KEY (id_tipo_escuela) REFERENCES TipoEscuela(id_tipo_escuela)
);

CREATE TABLE Personal (
    id_personal NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    apellido VARCHAR2(100) NOT NULL,
    profesion VARCHAR2(100),
    nacionalidad VARCHAR2(50),
    fecha_nacimiento DATE,
    id_escuela NUMBER,
    CONSTRAINT fk_escuela_personal FOREIGN KEY (id_escuela) REFERENCES EscuelaDeportiva(id_escuela)
);

CREATE TABLE Costos (
    id_costo NUMBER PRIMARY KEY,
    concepto VARCHAR2(100) NOT NULL,
    monto NUMBER(10, 2) NOT NULL,
    fecha DATE NOT NULL,
    id_escuela NUMBER,
    CONSTRAINT fk_escuela_costos FOREIGN KEY (id_escuela) REFERENCES EscuelaDeportiva(id_escuela)
);

-- Crear triggers
CREATE OR REPLACE TRIGGER trg_tipo_escuela_id
BEFORE INSERT ON TipoEscuela
FOR EACH ROW
BEGIN
    SELECT seq_tipo_escuela.NEXTVAL INTO :NEW.id_tipo_escuela FROM dual;
END;
/

CREATE OR REPLACE TRIGGER trg_escuela_deportiva_id
BEFORE INSERT ON EscuelaDeportiva
FOR EACH ROW
BEGIN
    SELECT seq_escuela_deportiva.NEXTVAL INTO :NEW.id_escuela FROM dual;
END;
/

CREATE OR REPLACE TRIGGER trg_personal_id
BEFORE INSERT ON Personal
FOR EACH ROW
BEGIN
    SELECT seq_personal.NEXTVAL INTO :NEW.id_personal FROM dual;
END;
/

CREATE OR REPLACE TRIGGER trg_costos_id
BEFORE INSERT ON Costos
FOR EACH ROW
BEGIN
    SELECT seq_costos.NEXTVAL INTO :NEW.id_costo FROM dual;
END;
/

-- Insertar datos de ejemplo
INSERT INTO TipoEscuela (nombre, descripcion) VALUES ('Fútbol', 'Escuela de fútbol para jóvenes');
INSERT INTO TipoEscuela (nombre, descripcion) VALUES ('Baloncesto', 'Escuela de baloncesto para todas las edades');
INSERT INTO TipoEscuela (nombre, descripcion) VALUES ('Natación', 'Escuela de natación y actividades acuáticas');
INSERT INTO TipoEscuela (nombre, descripcion) VALUES ('Atletismo', 'Escuela de atletismo y deportes de pista');

INSERT INTO EscuelaDeportiva (nombre, direccion, telefono, email, id_tipo_escuela) 
VALUES ('Gol Maestro', 'Av. Libertador 1234, Santiago', '+56912345678', 'info@golmaestro.cl', 1);
INSERT INTO EscuelaDeportiva (nombre, direccion, telefono, email, id_tipo_escuela) 
VALUES ('Canasta Dorada', 'Calle Los Deportes 567, Viña del Mar', '+56923456789', 'contacto@canastadorada.cl', 2);
INSERT INTO EscuelaDeportiva (nombre, direccion, telefono, email, id_tipo_escuela) 
VALUES ('Delfines Veloces', 'Paseo Costanera 890, Concepción', '+56934567890', 'info@delfinesveloces.cl', 3);
INSERT INTO EscuelaDeportiva (nombre, direccion, telefono, email, id_tipo_escuela) 
VALUES ('Corre Chile', 'Av. Olímpica 4321, Valparaíso', '+56945678901', 'contacto@correchile.cl', 4);

INSERT INTO Personal (nombre, apellido, profesion, nacionalidad, fecha_nacimiento, id_escuela) 
VALUES ('Juan', 'Pérez', 'Entrenador de Fútbol', 'Chilena', TO_DATE('1980-05-15', 'YYYY-MM-DD'), 1);
INSERT INTO Personal (nombre, apellido, profesion, nacionalidad, fecha_nacimiento, id_escuela) 
VALUES ('María', 'González', 'Preparadora Física', 'Argentina', TO_DATE('1985-09-22', 'YYYY-MM-DD'), 2);
INSERT INTO Personal (nombre, apellido, profesion, nacionalidad, fecha_nacimiento, id_escuela) 
VALUES ('Carlos', 'Muñoz', 'Instructor de Natación', 'Chilena', TO_DATE('1978-03-10', 'YYYY-MM-DD'), 3);
INSERT INTO Personal (nombre, apellido, profesion, nacionalidad, fecha_nacimiento, id_escuela) 
VALUES ('Ana', 'Soto', 'Entrenadora de Atletismo', 'Colombiana', TO_DATE('1982-11-30', 'YYYY-MM-DD'), 4);

INSERT INTO Costos (concepto, monto, fecha, id_escuela) 
VALUES ('Equipamiento de fútbol', 1500000, TO_DATE('2023-01-15', 'YYYY-MM-DD'), 1);
INSERT INTO Costos (concepto, monto, fecha, id_escuela) 
VALUES ('Mantenimiento cancha de baloncesto', 800000, TO_DATE('2023-02-20', 'YYYY-MM-DD'), 2);
INSERT INTO Costos (concepto, monto, fecha, id_escuela) 
VALUES ('Productos químicos para piscina', 500000, TO_DATE('2023-03-05', 'YYYY-MM-DD'), 3);
INSERT INTO Costos (concepto, monto, fecha, id_escuela) 
VALUES ('Implementos de atletismo', 1200000, TO_DATE('2023-04-10', 'YYYY-MM-DD'), 4);

COMMIT;

-- Consultas de ejemplo
SELECT * FROM EscuelaDeportiva;
SELECT nombre, apellido, profesion FROM Personal WHERE nacionalidad = 'Chilena';
SELECT ed.nombre AS escuela, SUM(c.monto) AS total_costos
FROM EscuelaDeportiva ed
JOIN Costos c ON ed.id_escuela = c.id_escuela
GROUP BY ed.id_escuela, ed.nombre;
SELECT ed.nombre AS escuela, te.nombre AS tipo_escuela
FROM EscuelaDeportiva ed
JOIN TipoEscuela te ON ed.id_tipo_escuela = te.id_tipo_escuela;
