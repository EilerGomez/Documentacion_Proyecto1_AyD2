DROP DATABASE IF EXISTS pruebaProyecto1;

CREATE DATABASE pruebaProyecto1
CHARACTER SET utf8mb4
COLLATE utf8mb4_spanish_ci;

USE pruebaProyecto1;

CREATE TABLE roles (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL UNIQUE-- ADMIN, EDITOR, SUSCRIPTOR, ANUNCIANTE
);

CREATE TABLE usuarios (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL UNIQUE,
    nombre VARCHAR(150),
    apellido VARCHAR(150),    
    correo VARCHAR(180) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    estado ENUM('ACTIVO','SUSPENDIDO','ELIMINADO') DEFAULT 'ACTIVO'
);

CREATE TABLE usuario_roles (
    usuario_id BIGINT,
    rol_id BIGINT,
    PRIMARY KEY (usuario_id, rol_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (rol_id) REFERENCES roles(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE perfiles (
    usuario_id BIGINT PRIMARY KEY,
    foto_url VARCHAR(500),
    hobbies TEXT,
    intereses TEXT,
    descripcion TEXT,
    gustos TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE carteras (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT UNIQUE,
    saldo DECIMAL(12,2) DEFAULT 0.00,
    moneda CHAR(3) DEFAULT 'GTQ',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE transacciones_cartera (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    cartera_id INT,
    tipo VARCHAR(16), -- 'RECARGA','COMPRA_ANUNCIO','BLOQUEO_ANUNCIO','PAGO_REVISTA','AJUSTE'
    direccion VARCHAR(7), -- 'CREDITO','DEBITO'
    monto DECIMAL(12,2),
    referencia_tipo VARCHAR(50),
    referencia_id INT,
    nota VARCHAR(255),
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_registrada_usuario DATE,
    FOREIGN KEY (cartera_id) REFERENCES carteras(id) ON DELETE CASCADE ON UPDATE CASCADE
);

insert into roles (nombre) values ("ADMIN"),("EDITOR"),("SUSCRIPTOR"),("ANUNCIANTE");


insert into usuarios(id, nombre,username,apellido,correo,password_hash) values (1,"administrador","admin1","1","gomezeiler250@gmail.com", "$2a$10$maFJe5RGwJUuIArBS9brxO.ZC6B1P4dzau7ZdxDiAJUJ.9emxnpEy"); -- admin123
insert into perfiles (usuario_id) values (1);
insert into carteras(usuario_id) values(1);

-- CREACION DE REVISTAS, ETIQUETAS, CATEGORIAS, ETC
CREATE TABLE categorias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(120) UNIQUE,
    descripcion VARCHAR(255)
);

CREATE TABLE etiquetas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(80) UNIQUE
);

CREATE TABLE revistas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    editor_id INT,
    titulo VARCHAR(200),
    descripcion TEXT,
    categoria_id INT,
    fecha_creacion DATE NOT NULL,
    activa BOOLEAN DEFAULT TRUE,
    permite_comentarios BOOLEAN DEFAULT TRUE,
    permite_likes BOOLEAN DEFAULT TRUE,
    permite_suscripciones BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (editor_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE revista_etiquetas (
    revista_id INT,
    etiqueta_id INT,
    PRIMARY KEY (revista_id, etiqueta_id),
    FOREIGN KEY (revista_id) REFERENCES revistas(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (etiqueta_id) REFERENCES etiquetas(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ediciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    revista_id INT,
    numero_edicion VARCHAR(60),
    titulo VARCHAR(200),
    pdf_url VARCHAR(700),
    fecha_publicacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (revista_id) REFERENCES revistas(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- SUSCRIPCIONES LIKES Y COMENTARIOS
CREATE TABLE suscripciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    revista_id INT,
    usuario_id INT,
    fecha_suscripcion DATE NOT NULL,
    activa BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (revista_id) REFERENCES revistas(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (revista_id, usuario_id)
);

CREATE TABLE likes_revista (
    id INT PRIMARY KEY AUTO_INCREMENT,
    revista_id INT,
    usuario_id INT,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (revista_id) REFERENCES revistas(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (revista_id, usuario_id)
);

CREATE TABLE comentarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    revista_id INT,
    usuario_id INT,
    contenido TEXT,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (revista_id) REFERENCES revistas(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE historial_costo_diario_revista (
    id INT PRIMARY KEY AUTO_INCREMENT,
    revista_id INT,
    admin_id INT,
    costo_por_dia DECIMAL(12,2),
    fecha_inicio DATE,
    fecha_fin DATE,
    FOREIGN KEY (revista_id) REFERENCES revistas(id),
    FOREIGN KEY (admin_id) REFERENCES usuarios(id)
);

CREATE TABLE pagos_revista (
    id INT PRIMARY KEY AUTO_INCREMENT,
    revista_id INT,
    editor_id INT,
    monto DECIMAL(12,2),
    fecha_pago DATE NOT NULL,
    periodo_inicio DATE,
    periodo_fin DATE,
    transaccion_id INT,
    FOREIGN KEY (revista_id) REFERENCES revistas(id),
    FOREIGN KEY (editor_id) REFERENCES usuarios(id),
    FOREIGN KEY (transaccion_id) REFERENCES transacciones_cartera(id)
);

INSERT INTO categorias (nombre, descripcion) VALUES 
('Hogar y Jardín', 'Decoración, bricolaje, jardinería y organización de espacios.'),
('Automotriz', 'Reseñas de vehículos, mecánica, industria automotriz y deportes de motor.'),
('Historia y Arqueología', 'Relatos del pasado, descubrimientos arqueológicos y civilizaciones antiguas.'),
('Psicología y Autoayuda', 'Bienestar emocional, desarrollo personal y comportamiento humano.'),
('Religión y Espiritualidad', 'Estudio de credos, prácticas espirituales y filosofía de vida.'),
('Música', 'Reseñas discográficas, perfiles de artistas y tendencias musicales.'),
('Videojuegos y E-sports', 'Análisis de juegos, consolas y el mundo competitivo de los e-sports.'),
('Infantil y Juvenil', 'Contenido educativo y de entretenimiento para niños y adolescentes.'),
('Arquitectura y Diseño', 'Planificación urbana, diseño de interiores y tendencias arquitectónicas.'),
('Derecho y Justicia', 'Análisis legal, jurisprudencia y temas de justicia social.'),
('Fotografía', 'Técnicas fotográficas, equipo, galerías y arte visual.'),
('Cine y Series', 'Crítica cinematográfica, estrenos y mundo del streaming.');


INSERT INTO etiquetas (nombre) VALUES 
('JavaScript'), ('Python'), ('Java'), ('Spring Boot'), ('React'), -- Programación
('Real Madrid'), ('FC Barcelona'), ('NBA'), ('Fórmula 1'), ('Tenis'), -- Deportes específicos
('Postres'), ('Comida Italiana'), ('Sushi'), ('Vinos'), ('Café'), -- Gastronomía
('Inversiones'), ('Bitcoin'), ('Acciones'), ('Startups'), ('Liderazgo'), -- Finanzas/Negocios
('Yoga'), ('Running'), ('Meditación'), ('Salud Mental'), ('Nutrición'), -- Salud
('NASA'), ('Cambio Climático'), ('Biología'), ('Física Cuántica'), -- Ciencia
('Netflix'), ('Marvel'), ('Anime'), ('Hollywood'), ('K-Pop'), -- Entretenimiento
('Europa'), ('Sudamérica'), ('Mochileros'), ('Hoteles de Lujo'), ('Playas'), -- Viajes
('DIY'), ('Minimalismo'), ('Vintage'), ('Plantas de interior'), -- Hogar
('Android'), ('iOS'), ('Gadgets'), ('Hardware'), ('Ciberseguridad'), -- Tecnología específica
('Derechos Humanos'), ('Elecciones'), ('Geopolítica'), ('Sustentabilidad'); -- Actualidad

USE proyecto1AyD2;
select * from roles;