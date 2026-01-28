class Environments {
  // API Key de Yuno - configúrala como variable de entorno o reemplaza directamente
  static const apiKey = String.fromEnvironment(
    'YUNO_API_KEY',
    defaultValue: 'your_api_key_here', // Reemplaza con tu API key real
  );
  
  // Configuraciones adicionales
  static const countryCode = String.fromEnvironment(
    'YUNO_COUNTRY_CODE',
    defaultValue: 'CO',
  );
  
  static const checkoutSession = String.fromEnvironment(
    'YUNO_CHECKOUT_SESSION',
    defaultValue: 'your_checkout_session_here', // Reemplaza con tu checkout session
  );
}
