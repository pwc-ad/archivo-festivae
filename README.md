# Festival Archive Database

Base de datos PostgreSQL para el archivo de obras y artistas del Festival de Artes Electrónicas de la UNTREF.

## 📋 Descripción

Este proyecto implementa una base de datos completa para gestionar:
- **Artistas** individuales y grupos
- **Obras** de arte electrónico con metadatos completos
- **Ediciones del festival** con estadísticas
- **Presentaciones** de obras en cada edición
- **Archivos multimedia** asociados a las obras
- **Relaciones complejas** entre artistas, grupos y obras

## 🏗️ Estructura de la Base de Datos

### Tablas Principales

| Tabla | Descripción |
|-------|-------------|
| `artists` | Artistas individuales |
| `groups` | Grupos de artistas |
| `works` | Obras/proyectos |
| `festival_editions` | Ediciones del festival |
| `presentations` | Presentaciones de obras |
| `media` | Archivos multimedia |

### Tablas de Relación

| Tabla | Descripción |
|-------|-------------|
| `group_members` | Relación artistas ↔ grupos |
| `work_artists` | Relación obras ↔ artistas |
| `work_groups` | Relación obras ↔ grupos |

### Vistas Útiles

| Vista | Descripción |
|-------|-------------|
| `works_with_artists` | Obras con información de creadores |
| `edition_stats` | Estadísticas por edición |
| `presentations_with_details` | Presentaciones con contexto completo |
| `artists_with_stats` | Artistas con estadísticas |

## 🚀 Instalación

### Prerrequisitos

- PostgreSQL 12 o superior
- Acceso de superusuario para crear la base de datos

### Configuración Rápida

1. **Clonar el repositorio:**
   ```bash
   git clone <repository-url>
   cd db-festivae
   ```

2. **Configurar credenciales:**
   Editar `setup_database.sh` y cambiar:
   ```bash
   DB_PASSWORD="tu_contraseña_segura"
   ```

3. **Ejecutar el script de instalación:**
   ```bash
   chmod +x setup_database.sh
   ./setup_database.sh
   ```

### Instalación Manual

1. **Crear la base de datos:**
   ```sql
   CREATE DATABASE festival_archive;
   CREATE USER festival_user WITH PASSWORD 'tu_contraseña';
   GRANT ALL PRIVILEGES ON DATABASE festival_archive TO festival_user;
   ```

2. **Ejecutar las migraciones en orden:**
   ```bash
   psql -U festival_user -d festival_archive -f migrations/001_create_artists_table.sql
   psql -U festival_user -d festival_archive -f migrations/002_create_groups_table.sql
   # ... continuar con todas las migraciones
   ```

## 📊 Características Principales

### 🔍 Búsqueda Avanzada
- **Búsqueda de texto completo** en títulos y descripciones
- **Búsqueda por etiquetas** usando arrays de PostgreSQL
- **Filtros por género, año, asignatura**
- **Búsqueda en campos JSONB** (links, feedback)

### 📈 Análisis y Reportes
- **Estadísticas por edición** del festival
- **Análisis de asistencia** y feedback
- **Comparación entre obras estudiantiles y profesionales**
- **Tendencias temporales** por año y mes

### 🔗 Relaciones Flexibles
- **Artistas individuales** y **grupos**
- **Obras colaborativas** con múltiples creadores
- **Roles específicos** en cada relación
- **Historial completo** de presentaciones

### 🎨 Soporte Multimedia
- **Imágenes, videos y audio** asociados a obras
- **Metadatos completos** (tamaño, tipo MIME, texto alternativo)
- **Organización por tipo** de medio

## 🛠️ Uso

### Conexión a la Base de Datos

```bash
# Conectar usando psql
psql -h localhost -p 5432 -U festival_user -d festival_archive

# O establecer variable de entorno
export PGPASSWORD='tu_contraseña'
psql -h localhost -p 5432 -U festival_user -d festival_archive
```

### Consultas de Ejemplo

```sql
-- Ver todas las obras con sus artistas
SELECT * FROM works_with_artists;

-- Estadísticas de ediciones
SELECT * FROM edition_stats;

-- Buscar obras por etiqueta
SELECT title, description FROM works WHERE 'interactivo' = ANY(tags);

-- Búsqueda de texto completo
SELECT title FROM works 
WHERE to_tsvector('spanish', title || ' ' || description) 
@@ plainto_tsquery('spanish', 'sonido interactivo');
```

### Consultas Avanzadas

Ver `sample_queries.sql` para ejemplos completos de:
- Análisis de artistas y grupos
- Estadísticas de presentaciones
- Análisis de feedback
- Reportes temporales
- Consultas de multimedia

## 📁 Estructura de Archivos

```
db-festivae/
├── migrations/                 # Migraciones de la base de datos
│   ├── 001_create_artists_table.sql
│   ├── 002_create_groups_table.sql
│   ├── 003_create_group_members_table.sql
│   ├── 004_create_works_table.sql
│   ├── 005_create_work_artists_table.sql
│   ├── 006_create_work_groups_table.sql
│   ├── 007_create_festival_editions_table.sql
│   ├── 008_create_presentations_table.sql
│   ├── 009_create_media_table.sql
│   ├── 010_create_views.sql
│   └── 011_insert_sample_data.sql
├── database_config.sql        # Configuración de la base de datos
├── setup_database.sh          # Script de instalación automática
├── sample_queries.sql         # Consultas de ejemplo
└── README.md                  # Este archivo
```

## 🔧 Configuración Avanzada

### Optimización de Rendimiento

Editar `database_config.sql` para ajustar parámetros según tu servidor:

```sql
-- Para servidores con 4GB+ RAM
ALTER SYSTEM SET shared_buffers = '1GB';
ALTER SYSTEM SET effective_cache_size = '3GB';
ALTER SYSTEM SET maintenance_work_mem = '256MB';
```

### Índices Personalizados

La base de datos incluye índices optimizados para:
- Búsquedas de texto completo
- Consultas por etiquetas
- Búsquedas en campos JSONB
- Joins entre tablas principales

## 📝 Datos de Ejemplo

El archivo `migrations/011_insert_sample_data.sql` incluye:
- 5 artistas (estudiantes y profesionales)
- 3 grupos de artistas
- 5 obras de diferentes géneros
- 2 ediciones del festival
- 5 presentaciones con feedback
- Archivos multimedia de ejemplo

## 🤝 Contribución

1. Fork el proyecto
2. Crear una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 🆘 Soporte

Para preguntas o problemas:
- Crear un issue en el repositorio
- Contactar al equipo de desarrollo
- Revisar la documentación de PostgreSQL

## 🔄 Migraciones Futuras

Para agregar nuevas funcionalidades:
1. Crear nueva migración numerada secuencialmente
2. Incluir rollback si es necesario
3. Actualizar este README
4. Probar con datos de ejemplo

---

**Desarrollado para el Festival de Artes Electrónicas UNTREF** 🎭
