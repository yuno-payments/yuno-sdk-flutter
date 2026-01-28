#!/bin/bash

echo "🚀 Configurando SDK de Yuno para desarrollo local..."

# Verificar que Flutter esté instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter no está instalado. Por favor instala Flutter primero."
    echo "Visita: https://docs.flutter.dev/get-started/install"
    exit 1
fi

# Instalar Melos globalmente
echo "📦 Instalando Melos..."
dart pub global activate melos

# Configurar dependencias del monorepo
echo "🔧 Configurando dependencias del monorepo..."
melos bootstrap

# Navegar al directorio example
cd example

# Obtener dependencias
echo "📱 Configurando aplicación de ejemplo..."
flutter pub get

# Crear archivo de configuración de entorno
echo "⚙️ Configurando variables de entorno..."
cat > .env << EOF
# Configuración para el SDK de Yuno
# Reemplaza con tu API Key real de Yuno
YUNO_API_KEY=your_api_key_here
EOF

echo "✅ Configuración completada!"
echo ""
echo "📋 Próximos pasos:"
echo "1. Edita el archivo example/.env y agrega tu API Key de Yuno"
echo "2. Ejecuta: cd example && flutter run"
echo "3. O para iOS: flutter run -d ios"
echo "4. O para Android: flutter run -d android"
echo ""
echo "🔍 Para probar cambios en el SDK:"
echo "- Modifica archivos en yuno_sdk/"
echo "- Los cambios se reflejarán automáticamente en la app example"
echo "- Usa 'melos test' para ejecutar tests"
