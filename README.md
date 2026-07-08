# Práctica: Diseño y Fragmentación de una Base de Datos Distribuida

Este repositorio contiene el código, los scripts SQL y el archivo de configuración necesarios para implementar la fragmentación horizontal, vertical y mixta sobre PostgreSQL (versión 16) utilizando contenedores Docker. 

El escenario modelado simula el sistema de ventas y clientes de una cafetería universitaria con tres sedes físicas: Campus, Babahoyo y Ventanas.

---

## Estructura del Repositorio

```text
.
├── README.md
└── practica-fragmentacion/
    ├── docker-compose.yml
    └── sql/
        ├── 01_esquema_central.sql
        ├── 02_datos.sql
        ├── 03_fragmentacion_horizontal.sql
        ├── 04_fragmentacion_vertical.sql
        ├── 05_fragmentacion_mixta.sql
        ├── 06_vistas_globales.sql
        └── 07_verificacion.sql
Prerrequisitos
Docker Desktop instalado y en ejecución.
Consola de comandos de PowerShell (recomendado para Windows).
Instrucciones de Ejecución
Nota: Para ejecutar estos comandos, abre tu consola de PowerShell posicionada dentro de la carpeta practica-fragmentacion/.
1. Despliegue de Contenedores
Desde la carpeta del proyecto, levanta los tres nodos de base de datos (pg-campus, pg-babahoyo, pg-ventanas):
code
Powershell
docker compose up -d
Verifica que los tres contenedores estén corriendo con el estado Up:
code
Powershell
docker compose ps
2. Creación del Esquema Centralizado (Referencia)
Crea las tablas iniciales en el nodo principal (pg-campus):
code
Powershell
Get-Content sql/01_esquema_central.sql | docker exec -i pg-campus psql -U admin -d cafeteria
3. Carga de Datos de Prueba
Puebla el esquema centralizado en pg-campus con los registros de prueba iniciales:
code
Powershell
Get-Content sql/02_datos.sql | docker exec -i pg-campus psql -U admin -d cafeteria
4. Fragmentación Horizontal (Pedidos)
Ejecuta la distribución de la tabla de pedidos en cada uno de los tres nodos según la sede de origen. Este proceso primero limpia el esquema centralizado en pg-campus para configurarlo únicamente como fragmento local.
Nodo pg-campus (Sede Campus):
code
Powershell
Get-Content sql/03_fragmentacion_horizontal.sql | Select-String -Pattern "DROP|CREATE|pedido_id|cliente_id|producto_id|fecha|monto|sede|\);" | docker exec -i pg-campus psql -U admin -d cafeteria
docker exec -i pg-campus psql -U admin -d cafeteria -c "INSERT INTO pedidos VALUES (1, 1, 1, '2026-03-01', 0.75, 'Campus');"
docker exec -i pg-campus psql -U admin -d cafeteria -c "INSERT INTO pedidos VALUES (3, 3, 2, '2026-03-02', 1.00, 'Campus');"
docker exec -i pg-campus psql -U admin -d cafeteria -c "INSERT INTO pedidos VALUES (7, 1, 3, '2026-03-04', 2.50, 'Campus');"
Nodo pg-babahoyo (Sede Babahoyo):
code
Powershell
Get-Content sql/03_fragmentacion_horizontal.sql | Select-String -Pattern "DROP|CREATE|pedido_id|cliente_id|producto_id|fecha|monto|sede|\);" | docker exec -i pg-babahoyo psql -U admin -d cafeteria
docker exec -i pg-babahoyo psql -U admin -d cafeteria -c "INSERT INTO pedidos VALUES (2, 2, 3, '2026-03-01', 2.50, 'Babahoyo');"
docker exec -i pg-babahoyo psql -U admin -d cafeteria -c "INSERT INTO pedidos VALUES (6, 6, 1, '2026-03-03', 0.75, 'Babahoyo');"
docker exec -i pg-babahoyo psql -U admin -d cafeteria -c "INSERT INTO pedidos VALUES (8, 2, 2, '2026-03-04', 1.00, 'Babahoyo');"
Nodo pg-ventanas (Sede Ventanas):
code
Powershell
Get-Content sql/03_fragmentacion_horizontal.sql | Select-String -Pattern "DROP|CREATE|pedido_id|cliente_id|producto_id|fecha|monto|sede|\);" | docker exec -i pg-ventanas psql -U admin -d cafeteria
docker exec -i pg-ventanas psql -U admin -d cafeteria -c "INSERT INTO pedidos VALUES (4, 4, 4, '2026-03-02', 1.25, 'Ventanas');"
docker exec -i pg-ventanas psql -U admin -d cafeteria -c "INSERT INTO pedidos VALUES (5, 5, 5, '2026-03-03', 1.00, 'Ventanas');"
5. Fragmentación Vertical (Clientes)
Divide las columnas de la tabla de clientes según su sensibilidad (datos públicos en pg-campus y datos de contacto en pg-babahoyo).
Nodo pg-campus (Clientes Públicos):
code
Powershell
Get-Content sql/04_fragmentacion_vertical.sql | Select-String -Pattern "DROP|CREATE|clientes_publicos|cliente_id|nombre|ciudad|\);" | docker exec -i pg-campus psql -U admin -d cafeteria
docker exec -i pg-campus psql -U admin -d cafeteria -c "INSERT INTO clientes_publicos VALUES (1, 'Maria Alvarado', 'Quevedo'), (2, 'Luis Cedeno', 'Babahoyo'), (3, 'Ana Vera', 'Quevedo'), (4, 'Jose Mendoza', 'Ventanas'), (5, 'Carla Zambrano', 'Ventanas'), (6, 'Pedro Suarez', 'Babahoyo');"
Nodo pg-babahoyo (Clientes de Contacto):
code
Powershell
Get-Content sql/04_fragmentacion_vertical.sql | Select-String -Pattern "DROP|CREATE|clientes_contacto|cliente_id|email|telefono|\);" | docker exec -i pg-babahoyo psql -U admin -d cafeteria
docker exec -i pg-babahoyo psql -U admin -d cafeteria -c "INSERT INTO clientes_contacto VALUES (1, 'maria@uteq.edu.ec', '0991111111'), (2, 'luis@uteq.edu.ec', '0992222222'), (3, 'ana@uteq.edu.ec', '0993333333'), (4, 'jose@uteq.edu.ec', '0994444444'), (5, 'carla@uteq.edu.ec', '0995555555'), (6, 'pedro@uteq.edu.ec', '0996666666');"
6. Fragmentación Mixta (Clientes por Ciudad y Sensibilidad)
Aplica la matriz de corte mixto dividiendo registros por ubicación (ciudad de Quevedo frente a otras ubicaciones) y luego separando sus columnas.
Nodo pg-campus (Públicos - Quevedo):
code
Powershell
Get-Content sql/05_fragmentacion_mixta.sql | Select-String -Pattern "DROP|CREATE|clientes_pub_quevedo|cliente_id|nombre|ciudad|\);" | docker exec -i pg-campus psql -U admin -d cafeteria
docker exec -i pg-campus psql -U admin -d cafeteria -c "INSERT INTO clientes_pub_quevedo VALUES (1, 'Maria Alvarado', 'Quevedo'), (3, 'Ana Vera', 'Quevedo');"
Nodo pg-ventanas (Públicos - Babahoyo/Ventanas):
code
Powershell
Get-Content sql/05_fragmentacion_mixta.sql | Select-String -Pattern "DROP|CREATE|clientes_pub_otros|cliente_id|nombre|ciudad|\);" | docker exec -i pg-ventanas psql -U admin -d cafeteria
docker exec -i pg-ventanas psql -U admin -d cafeteria -c "INSERT INTO clientes_pub_otros VALUES (2, 'Luis Cedeno', 'Babahoyo'), (4, 'Jose Mendoza', 'Ventanas'), (5, 'Carla Zambrano', 'Ventanas'), (6, 'Pedro Suarez', 'Babahoyo');"
Nodo pg-babahoyo (Contactos - Ambos Grupos):
code
Powershell
Get-Content sql/05_fragmentacion_mixta.sql | Select-String -Pattern "DROP|CREATE|clientes_con_quevedo|clientes_con_otros|cliente_id|email|telefono|\);" | docker exec -i pg-babahoyo psql -U admin -d cafeteria
docker exec -i pg-babahoyo psql -U admin -d cafeteria -c "INSERT INTO clientes_con_quevedo VALUES (1, 'maria@uteq.edu.ec', '0991111111'), (3, 'ana@uteq.edu.ec', '0993333333');"
docker exec -i pg-babahoyo psql -U admin -d cafeteria -c "INSERT INTO clientes_con_otros VALUES (2, 'luis@uteq.edu.ec', '0992222222'), (4, 'jose@uteq.edu.ec', '0994444444'), (5, 'carla@uteq.edu.ec', '0995555555'), (6, 'pedro@uteq.edu.ec', '0996666666');"
7. Enlaces y Vistas Globales
Crea la infraestructura postgres_fdw y las vistas globales consolidadas ejecutando en el nodo pg-campus:
code
Powershell
Get-Content sql/06_vistas_globales.sql | docker exec -i pg-campus psql -U admin -d cafeteria
8. Verificación de las Tres Condiciones de Fragmentación
Ejecuta las consultas para verificar Completitud, Reconstrucción y Disyunción (ejecución exclusiva en pg-campus):
code
Powershell
Get-Content sql/07_verificacion.sql | docker exec -i pg-campus psql -U admin -d cafeteria
