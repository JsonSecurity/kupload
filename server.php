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

        if (move_uploaded_file($archivo['tmp_name'], 'uploads/' . $nombre_final)) {
            // Archivo subido correctamente
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
