lambdas = {
  main = {
    memory_size = 128
    runtime = "nodejs14.x"
    handler = "main.handler"
    route_key = "GET /api/pets"
  }
  secondary = {
    memory_size = 256
    runtime = "nodejs14.x"
    handler = "secondary.handler"
    route_key = "GET /api/foods"
  }
}
s3_bucket = "terraform-serverless-example-13437"
domain = "chrisdurand.net"
mime_types = {
  ".txt"    = "text/plain; charset=utf-8"
  ".html"   = "text/html; charset=utf-8"
  ".htm"    = "text/html; charset=utf-8"
  ".xhtml"  = "application/xhtml+xml"
  ".css"    = "text/css; charset=utf-8"
  ".js"     = "application/javascript"
  ".xml"    = "application/xml"
  ".json"   = "application/json"
  ".jsonld" = "application/ld+json"
  ".gif"    = "image/gif"
  ".jpeg"   = "image/jpeg"
  ".jpg"    = "image/jpeg"
  ".png"    = "image/png"
  ".svg"    = "image/svg+xml; charset=UTF-8"
  ".webp"   = "image/webp"
  ".weba"   = "audio/webm"
  ".webm"   = "video/webm"
  ".3gp"    = "video/3gpp"
  ".3g2"    = "video/3gpp2"
  ".pdf"    = "application/pdf"
  ".swf"    = "application/x-shockwave-flash"
  ".atom"   = "application/atom+xml"
  ".rss"    = "application/rss+xml"
  ".ico"    = "image/vnd.microsoft.icon"
  ".jar"    = "application/java-archive"
  ".ttf"    = "font/ttf"
  ".otf"    = "font/otf"
  ".eot"    = "application/vnd.ms-fontobject"
  ".woff"   = "font/woff"
  ".woff2"  = "font/woff2"
}