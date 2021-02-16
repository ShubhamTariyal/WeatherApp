
const weatherApp = "Weather App";

//API key
const apiKey = "8815198221c5453da57142206212901";
//Base url for API calling
const baseUrl = "http://api.weatherapi.com/v1";

//Base url for api calling
const currentUrl = "$baseUrl/current.json?key=$apiKey";

//Base url for api calling
const searchUrl = "$baseUrl/search.json?key=$apiKey";

//Error Messages
const permissionDeniedPermanentlyErrorMessage = "GPS permission is denied. Goto app settings to enable";

const permissionDeniedErrorMessage = "GPS permission is denied";

const locationServiceErrorMessage = "Location services are disabled.Try again after enabling GPS";

// default message to show incase no message is provided.
const defaultServiceWeatherExceptionMessage = "Exception:ServiceNotEnabled";

const humidity = "Humidity";

const windSpeed = "Wind Speed";

const unit = "Km/h";
//Weather Images Base Dir Path
const weatherImagesBaseDirPath = "assets/img/weather/64x64";
//Throw when there is some unexpected error
const unknownWeatherExceptionMessage = "Unknown Error! Check Internet Connection, Permission for GPS and turn On GPS";

//Api Error Messages

const apiKeyNotProvidedMessage = "API key not provided";

const properQueryNotProvidedMessage = "Proper Query not provided";

const invalidApiRequestUrlMessage = "API request url is invalid";

const noMatchingLocationMessage =  "No matching location found";

const invalidApiKeyMessage = "API key provided is invalid";

const callLimitExceededMessage = "API key has exceeded calls per month quota";

const apiKeyDisabledMessage = "API key has been disabled";

const internalApplicationErrorMessage = "Internal application error";

const otherErrorMessage = "Error 404\nSome Unknown Error Occurred";

const askGpsPermissionMessage = "Give GPS Permission";

const location = "Location";



