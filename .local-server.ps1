$root = 'C:\Users\Lenovo\Desktop\Introduction'
$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add('http://localhost:8000/')
$listener.Start()
$types = @{
  '.html' = 'text/html; charset=utf-8'
  '.css' = 'text/css; charset=utf-8'
  '.js' = 'application/javascript; charset=utf-8'
  '.png' = 'image/png'
  '.jpg' = 'image/jpeg'
  '.jpeg' = 'image/jpeg'
  '.webp' = 'image/webp'
  '.svg' = 'image/svg+xml'
}
while ($listener.IsListening) {
  $context = $listener.GetContext()
  $path = [Uri]::UnescapeDataString($context.Request.Url.AbsolutePath.TrimStart('/'))
  if ([string]::IsNullOrWhiteSpace($path)) { $path = 'index.html' }
  $full = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($root, $path))
  if (-not $full.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase) -or -not [System.IO.File]::Exists($full)) {
    $context.Response.StatusCode = 404
    $bytes = [Text.Encoding]::UTF8.GetBytes('Not found')
  } else {
    $context.Response.StatusCode = 200
    $ext = [System.IO.Path]::GetExtension($full).ToLowerInvariant()
    $context.Response.ContentType = if ($types.ContainsKey($ext)) { $types[$ext] } else { 'application/octet-stream' }
    $bytes = [System.IO.File]::ReadAllBytes($full)
  }
  $context.Response.ContentLength64 = $bytes.Length
  $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
  $context.Response.OutputStream.Close()
}
