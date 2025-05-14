# Capacitor Base (Quasar App Android)

Proyecto base para aplicaciones de android en quasar capacitor

## Requisitos

- Docker Desktop

## Levantar el entorno de desarrollo

### Construir imagen docker

```bash
docker-compose build
```

### Levantar contenedor docker

```bash
docker-compose up -d
```

Si llega a abrirse un pop-up preguntando si se desea compartir la ubicacion, responder que si y volver a ejecutar el comando.
Luego de levantado se debe adjuntar una consola al contenedor de docker para ejecutar comandos en ella.

### Instalar dependencias

```bash
npm install
```

## Iniciar la aplicacion web

```bash
quasar dev
```

Hasta este punto ya se puede iniciar la aplicacion como una aplicación web en la que se levantará una pagina en la dirección [http://localhost:9000](http://localhost:9000).

## Preparar compilacion android

### Añadimos capacitor

```bash
quasar mode add capacitor
```

En este paso se debe definir el dominio de la aplicacion. e.g. com.omegacorp.capacitorapp.

### Modificamos version de capacitor que usaremos

Se debe eliminar la carpeta ./src-capacitor/node_modules y ./src-capacitor/package-lock.json, ya que debemos modificar una dependencia y volver a descargar los paquetes.

Luego de que se ejecute este proceso se debe modificar el archivo ./src-capacitor/package.json.

Se deben modificar las dependencias de la siguiente manera:

```JSON
"dependencies": {
  "@capacitor/app": "^6.0.0",
  "@capacitor/cli": "^6.0.0",
  "@capacitor/core": "^6.0.0",
  "@capacitor/splash-screen": "^6.0.0"
}
```

Ingresamos a la carpeta de capacitor, volvemos a descargar los paquetes y salimos.

```bash
cd src-capacitor/
npm install
cd ..
quasar build -m capacitor -T android
```

Esta compilacion generará un archivo APK no firmado.

### Generamos certificado de firmado de aplicaciones

```bash
cd src-capacitor/android/app
keytool -genkeypair -v -keystore my-release-key.keystore -alias my_app -keyalg RSA -keysize 2048 -validity 10000
cd ../../..
```

Generamos un certificado propio para firmar la apk y modificamos las configuraciones de compilacion de gradle (./src-capacitor/android/app/build.gradle) para que las utilice.

```gradle
android {

    signingConfigs {
        release {
            storeFile file("my-release-key.keystore")
            storePassword "your_keystore_password"
            keyAlias "my_app"
            keyPassword "your_key_password"
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true // Recommended for release builds
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
        debug {
            // No usado
        }
    }
}
```

### Compilar APK

```bash
quasar build -m capacitor -T android
```

Esto generará la APK firmada en la carpeta ./dist/capacitor/android/apk/release.

Para instalarla en un celular conectado a la computadora por USB (Que tenga las opciones de desarrollador hablitadas) se debe ejecutar:

```bash
adb install .\app-release.apk
```
