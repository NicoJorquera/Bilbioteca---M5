create table Personas(
	id int not null,
	nombre varchar(50),
	apellido varchar(50),
	RUT varchar(12),
	fecha_nacim varchar(8),
	primary key (id));

create table Contacto(
	id int not null,
	direccion varchar(100),
	telefono varchar(12),
	primary key (id));
	
create table Socio(
	id int not null,
	persona_id int,
	contacto_id int,
	foreign key (persona_id) references Personas(id),
	foreign key (contacto_id) references Contacto(id),
	primary key (id));
	
create table Autor_Coautor(
	id int not null,
	persona_id int,
	fecha_muerte varchar(8),
	foreign key (persona_id) references Personas(id),
	primary key (id));

create table Libro(
	id int not null,
	ISBN varchar(15),
	titulo varchar(50),
	numero_paginas int,
	autor_id int,
	coautor_id int,
	foreign key (autor_id) references Autor_Coautor(id),
	foreign key (coautor_id) references Autor_Coautor(id),
	primary key (id));

create table Prestamo(
	id int not null,
	id_socio int,
	id_libro int,
	fecha_inicio date,
	fecha_esperada date,
	fecha_entrega date,
	foreign key(id_socio) references Socio(id),
	foreign key(id_libro) references Libro(id),
	primary key(id));

insert into Contacto values
(1, 'Avenida 1, Santiago', '911111111'),
(2, 'Pasaje 2, Santiago', '922222222'),
(3, 'Avenida 2, Santiago', '933333333'),
(4, 'Avenida 3, Santiago', '944444444'),
(5, 'Pasaje 3, Santiago', '955555555');

insert into Personas values
(1, 'Juan', 'Soto', '1111111-1', null),
(2, 'Ana', 'Perez', '2222222-2', null),
(3, 'Sandra', 'Aguilar', '3333333-3', null),
(4, 'Esteban', 'Jerez', '4444444-4', null),
(5, 'Silvana', 'Muñoz', '5555555-5', null);
insert into Personas values -- Estos son los Autores que fueron agregados.
(6, 'Andres', 'Ulloa', null, '1982'),
(7, 'Sergio', 'Mardones', null, '1950'),
(8, 'Jose', 'Salgado', null, '1968'),
(9, 'Ana', 'Salgado', null, '1972'),
(10, 'Martin', 'Porta', null, '1976');

-- delete from Personas;
select * from Personas;

insert into Socio values
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5);

select * from Socio;

/*select * from Contacto inner join Socio on Socio.contacto_id=Contacto.id;
select * from Personas inner join Socio on Socio.persona_id=Personas.id;*/

-- Esto genera la tabla Socios, con las caracteristicas correspondientes
select * from Personas
inner join Socio on Socio.persona_id= Personas.id
inner join Contacto on Socio.contacto_id= Contacto.id;

insert into Autor_Coautor values
(1, 8, '2020'), -- Autor 8: Jose Salgado
(2, 9, null), -- Autor 9: Ana Salgado
(3, 6, null), -- 6: Andres Ulloa
(4, 7, '2012'), -- 7: Sergio Mardones
(5, 10, null); -- 10: Martin Porta

insert into Libro values -- los numeros despues de pag corresponde a la tabla Autor_Coautor
(1, '111-1111111-111', 'Cuentos de Terror', 344, 1, 2),
/*(2, '111-1111111-111', 'Cuentos de Terror', 344, null, 2),*/
(3, '222-2222222-222', 'Poesias Contemporaneas', 167, 3, null),
(4, '333-3333333-333', 'Historia de Asia', 511, 4, null),
(5, '444-4444444-444', 'Manual de Mecanica', 298, 5, null);

-- drop table Socio, Prestamo, Personas, Libro, Contacto, Autor_Coautor;

/*ALTER TABLE public.libro ADD coautor_id int4 NOT NULL;
ALTER TABLE public.libro ADD CONSTRAINT libro_fk_1 FOREIGN KEY (coautor_id) REFERENCES public.autor_coautor(id);*/

-- Esto genera la tabla de Libros con sus respectivas caracteristicas
select l.ISBN, l.titulo, l.numero_paginas,
  	concat(p.nombre,' ',p.apellido) as autor,
    concat(pc.nombre,' ',pc.apellido) as coautor from libro l 
inner join Autor_Coautor ac on ac.id = l.autor_id 
inner join Personas p on p.id = ac.persona_id

left join Autor_Coautor acd on acd.id = l.coautor_id 
left join Personas pc on pc.id = acd.persona_id;

insert into Prestamo values
(1, 1, 1, '2020-01-20', '2020-01-27', '2020-01-29'),
(2, 5, 3, '2020-01-20', '2020-01-30', '2020-01-30'),
(3, 3, 4, '2020-01-22', '2020-01-30', '2020-02-07'),
(4, 4, 5, '2020-01-23', '2020-01-30', '2020-01-31'),
(5, 2, 1, '2020-01-27', '2020-02-04', '2020-02-11'),
(6, 1, 5, '2020-01-31', '2020-02-12', '2020-02-12'),
(7, 3, 3, '2020-01-31', '2020-02-12', '2020-02-13');

-- Tabla de Prestamo
select l.isbn, l.titulo,p.fecha_inicio, p.fecha_esperada , p.fecha_entrega,
concat(p2.nombre, ' ', p2.apellido) as socio 
from prestamo p 
inner join Libro l on l.id = p.id_libro 
inner join Socio s on s.id = p.id_libro 
inner join Personas p2 on p2.id = s.persona_id;

-- Los libro que tiene menos de 300 paginas
SELECT * FROM libro WHERE numero_paginas < 300;

-- Autores que nacieran mayor al 1970
SELECT * FROM Personas WHERE fecha_nacim > '1970';

-- Libro mas solicitado
SELECT  titulo AS titulo_mas_vendido ,COUNT(id_libro) FROM prestamo
INNER JOIN libro ON prestamo.id_libro = libro.id
GROUP BY  titulo ORDER BY count desc LIMIT 1;

--  Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto debería pagar cada usuario
-- que entregue el préstamo después de 7 días.

/*select sum (fecha_entrega - fecha_esperada) from Prestamo where Prestamo.id= 3;

select id_socio, fecha_entrega:: DATE - fecha_esperada::DATE from 
Prestamo where fecha_entrega::DATE - fecha_esperada::DATE > 7;*/

select l.isbn, l.titulo,
concat(p2.nombre, ' ', p2.apellido) as socio,
date_part('day', p.fecha_entrega::timestamp - p.fecha_esperada::timestamp) as dias_atraso,
date_part('day', p.fecha_entrega::timestamp - p.fecha_esperada::timestamp) * 100 as multa
from Prestamo p
inner join Libro l on l.id = p.id_libro
inner join Socio s on s.id = p.id_socio 
inner join Personas p2 on p2.id = s.persona_id
where fecha_entrega::DATE - fecha_esperada::DATE >= 7;