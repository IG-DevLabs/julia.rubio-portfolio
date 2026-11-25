const http = require('node:http');
const fs = require('node:fs');
const path = require('node:path');
const root = path.resolve(process.argv[2]);
const port = Number(process.argv[3] || 8000);
const mime = { '.html':'text/html; charset=utf-8', '.css':'text/css; charset=utf-8', '.js':'text/javascript; charset=utf-8', '.webp':'image/webp', '.png':'image/png', '.jpg':'image/jpeg', '.jpeg':'image/jpeg', '.svg':'image/svg+xml', '.ico':'image/x-icon', '.mp4':'video/mp4', '.webm':'video/webm', '.m4a':'audio/mp4', '.woff':'font/woff', '.woff2':'font/woff2', '.ttf':'font/ttf', '.otf':'font/otf' };
http.createServer((req, res) => {
  let pathname;
  try { pathname = decodeURIComponent(new URL(req.url, 'http://localhost').pathname); }
  catch { res.writeHead(400); res.end(); return; }
  let file = path.resolve(root, '.' + pathname);
  if (file !== root && !file.startsWith(root + path.sep)) { res.writeHead(403); res.end(); return; }
  fs.stat(file, (err, stat) => {
    if (err) { res.writeHead(404); res.end('Not found'); return; }
    if (stat.isDirectory()) file = path.join(file, 'index.html');
    fs.stat(file, (fileErr, fileStat) => {
      if (fileErr || !fileStat.isFile()) { res.writeHead(404); res.end('Not found'); return; }
      const headers = { 'Content-Type': mime[path.extname(file).toLowerCase()] || 'application/octet-stream', 'Accept-Ranges':'bytes' };
      const match = /^bytes=(\d*)-(\d*)$/.exec(req.headers.range || '');
      if (match) {
        const start = match[1] ? Number(match[1]) : Math.max(0, fileStat.size - Number(match[2]));
        const end = match[2] && match[1] ? Math.min(Number(match[2]), fileStat.size - 1) : fileStat.size - 1;
        if (start > end || start >= fileStat.size) { res.writeHead(416, { 'Content-Range': `bytes */${fileStat.size}` }); res.end(); return; }
        headers['Content-Range'] = `bytes ${start}-${end}/${fileStat.size}`;
        headers['Content-Length'] = end - start + 1;
        res.writeHead(206, headers);
        if (req.method === 'HEAD') { res.end(); return; }
        fs.createReadStream(file, { start, end }).pipe(res);
        return;
      }
      headers['Content-Length'] = fileStat.size;
      res.writeHead(200, headers);
      if (req.method === 'HEAD') { res.end(); return; }
      fs.createReadStream(file).pipe(res);
    });
  });
}).listen(port, '127.0.0.1', () => console.log(`Serving ${root} at http://127.0.0.1:${port}`));
