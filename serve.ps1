$root = "C:\Users\liber\game by Claude Code"
$port = 7874 # สะกดด้วยปุ่มโทรศัพท์ (T9) = R-U-S-H ผูกกับชื่อเกม Order Rush ไม่ใช่เลขทั่วไปแบบ 8080
$listener = New-Object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Any, $port)
$listener.Start()
Write-Host "Serving $root on port $port (TCP raw, no admin needed)"

function Get-ContentType($ext) {
    switch ($ext) {
        ".html" { "text/html" }
        ".js"   { "application/javascript" }
        ".css"  { "text/css" }
        default { "application/octet-stream" }
    }
}

while ($true) {
    $client = $listener.AcceptTcpClient()
    try {
        $stream = $client.GetStream()
        $reader = New-Object System.IO.StreamReader($stream)
        $requestLine = $reader.ReadLine()
        # อ่าน header ทิ้งจนกว่าจะถึงบรรทัดว่าง (เราไม่สน header แค่ต้องการ path)
        while (($line = $reader.ReadLine()) -ne "" -and $line -ne $null) {}

        $path = "/index.html"
        if ($requestLine -match '^GET\s+(\S+)\s+HTTP') {
            $p = $matches[1]
            if ($p -eq "/") { $path = "/index.html" } else { $path = $p }
        }

        $filePath = Join-Path $root ($path.TrimStart("/") -replace '/', '\')
        $writer = New-Object System.IO.StreamWriter($stream)
        $writer.AutoFlush = $false

        if (Test-Path $filePath -PathType Leaf) {
            $bytes = [System.IO.File]::ReadAllBytes($filePath)
            $ext = [System.IO.Path]::GetExtension($filePath)
            $contentType = Get-ContentType $ext
            $header = "HTTP/1.1 200 OK`r`nContent-Type: $contentType`r`nContent-Length: $($bytes.Length)`r`nConnection: close`r`n`r`n"
            $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($header)
            $stream.Write($headerBytes, 0, $headerBytes.Length)
            $stream.Write($bytes, 0, $bytes.Length)
        } else {
            $body = "404 Not Found: $path"
            $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($body)
            $header = "HTTP/1.1 404 Not Found`r`nContent-Type: text/plain`r`nContent-Length: $($bodyBytes.Length)`r`nConnection: close`r`n`r`n"
            $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($header)
            $stream.Write($headerBytes, 0, $headerBytes.Length)
            $stream.Write($bodyBytes, 0, $bodyBytes.Length)
        }
        $stream.Flush()
    } catch {
    } finally {
        $client.Close()
    }
}
