<?php

if (isset($_FILES['archivo'])) {
    $archivo = $_FILES['archivo'];

    if ($archivo['error'] === 0) {
        $extension = pathinfo($archivo['name'], PATHINFO_EXTENSION);
        $nombre_original = pathinfo($archivo['name'], PATHINFO_FILENAME);

        // Si se envía el parámetro "random", agregar sufijo aleatorio
        if (isset($_POST['random'])) {
            $sufijo = substr(str_shuffle('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'), 0, 4);
            $nombre_final = $nombre_original . '_' . $sufijo . '.' . $extension;
        } else {
            $nombre_final = $nombre_original . '.' . $extension;
        }

        // Crear la carpeta 'uploads' si no existe
        $directorio = 'uploads';
        if (!is_dir($directorio)) {
            if (!mkdir($directorio, 0755, true)) {
                error_log("[!] No se pudo crear el directorio 'uploads'.");
                exit;
            }
        }

        $ruta_destino = $directorio . '/' . $nombre_final;

        if (move_uploaded_file($archivo['tmp_name'], $ruta_destino)) {
            // Archivo subido correctamente
            header("Location: index.php");
        } else {
            error_log("[!] Error al mover el archivo.");
        }
    } else {
        error_log("[!] Error en la subida del archivo. Código de error: " . $archivo['error']);
    }
} else {
    error_log("[!] No se recibió ningún archivo.");
}

?>
