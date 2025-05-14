<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Subir Archivo</title>
  <style>
    * {
      box-sizing: border-box;
    }

    body {
      font-family: 'Segoe UI', sans-serif;
      background: linear-gradient(to right, #f7f9fc, #e4ecf7);
      margin: 0;
      padding: 0;
      height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .upload-container {
      background-color: white;
      width: 90%;
      max-width: 400px;
      padding: 25px 20px;
      border-radius: 12px;
      box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
      text-align: center;
    }

    .upload-container h2 {
      margin-bottom: 25px;
      color: #333;
      font-size: 1.5rem;
    }

    label.custom-file-input {
      display: block;
      background-color: #f0f0f0;
      padding: 12px;
      border-radius: 8px;
      border: 2px dashed #ccc;
      cursor: pointer;
      margin-bottom: 10px;
      color: #666;
      font-size: 1rem;
      transition: all 0.3s ease;
    }

    label.custom-file-input:hover {
      background-color: #e9e9e9;
      border-color: #999;
    }

    input[type="file"] {
      display: none;
    }

    .file-name {
      margin-bottom: 15px;
      color: #333;
      font-size: 0.95rem;
      font-style: italic;
    }

    .upload-btn {
      background-color: #007BFF;
      color: white;
      padding: 12px 20px;
      font-size: 1rem;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      width: 100%;
      transition: background-color 0.3s ease;
    }

    .upload-btn:hover {
      background-color: #0056b3;
    }

    .loading {
      margin-top: 15px;
      font-size: 1rem;
      color: #555;
      animation: blink 1s infinite;
    }

    @keyframes blink {
      0%, 100% { opacity: 1; }
      50% { opacity: 0.4; }
    }
  </style>
</head>
<body>

<div class="upload-container">
  <h2>Subir Archivo</h2>
  <form id="upload-form" action="server.php" method="post" enctype="multipart/form-data">
    <label class="custom-file-input">
      Selecciona un archivo
      <input type="file" name="archivo" id="archivo">
    </label>
    <div class="file-name" id="file-name">Ningún archivo seleccionado</div>
    <button type="submit" class="upload-btn">Subir archivo</button>
    <div class="loading" id="loading" style="display: none;">Subiendo archivo...</div>
  </form>
</div>

<script>
  const inputFile = document.getElementById('archivo');
  const fileNameDisplay = document.getElementById('file-name');
  const form = document.getElementById('upload-form');
  const loading = document.getElementById('loading');

  inputFile.addEventListener('change', () => {
    const fileName = inputFile.files.length > 0 ? inputFile.files[0].name : 'Ningún archivo seleccionado';
    fileNameDisplay.textContent = fileName;
  });

  form.addEventListener('submit', function (e) {
    if (inputFile.files.length === 0) {
      e.preventDefault();
      alert('Por favor selecciona un archivo antes de subir.');
      return;
    }
    loading.style.display = 'block';
  });
</script>

</body>
</html>
