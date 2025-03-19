# El Camino App

Aplicación web para el proyecto El Camino, desarrollada con Nuxt.js (frontend) y FastAPI (backend).

## Estructura del Proyecto

```
elcamino-app/
├── frontend/                 # Aplicación Nuxt.js
│   ├── assets/              # Recursos estáticos
│   ├── components/          # Componentes Vue
│   ├── layouts/             # Layouts de la aplicación
│   ├── pages/               # Páginas/rutas
│   ├── public/              # Archivos públicos
│   ├── server/              # Funciones serverless
│   └── utils/               # Utilidades
│
└── backend/                  # Backend FastAPI
    ├── src/                 # Código fuente
    │   ├── api/            # Endpoints
    │   └── utils/          # Utilidades
    └── tests/              # Tests
```

## Requisitos

- Node.js 16+
- Python 3.8+
- npm o yarn
- pip

## Instalación

### Frontend

```bash
cd frontend
npm install
```

### Backend

```bash
cd backend
python -m venv venv
source venv/bin/activate  # En Windows: venv\Scripts\activate
pip install -r requirements.txt
```

## Desarrollo Local

### Frontend

```bash
cd frontend
npm run dev
```

El frontend estará disponible en http://localhost:3000

### Backend

```bash
cd backend
./scripts/dev.sh
```

El backend estará disponible en http://localhost:8000

## Variables de Entorno

### Frontend
Crear archivo `.env.development` en el directorio `frontend/` con:

```
API_BASE_URL=http://localhost:8000
```

### Backend
Copiar `.env.example` a `.env.development` en el directorio `backend/` y configurar las variables necesarias.

## Despliegue

- Frontend: Vercel
- Backend: AWS Lambda

## Scripts Disponibles

### Frontend
- `npm run dev`: Inicia el servidor de desarrollo
- `npm run build`: Compila para producción
- `npm run preview`: Previsualiza la versión de producción

### Backend
- `./scripts/dev.sh`: Inicia el servidor de desarrollo