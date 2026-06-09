import { createReadStream, existsSync, statSync } from "node:fs";
import { createServer } from "node:http";
import { extname, join, normalize, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const DEFAULT_ROOT = "/opt/mantaculus/projects/Tax_Lawyer/Tax_Lawyer_deploy/tax-lawyer-game/builds/web";
const WEB_ROOT = resolve(process.env.WEB_ROOT || DEFAULT_ROOT);
const HOST = process.env.HOST || "127.0.0.1";
const PORT = Number.parseInt(process.env.PORT || "18081", 10);

const MIME_TYPES = {
	".html": "text/html; charset=utf-8",
	".js": "text/javascript; charset=utf-8",
	".wasm": "application/wasm",
	".pck": "application/octet-stream",
	".png": "image/png",
	".ico": "image/x-icon",
	".json": "application/json; charset=utf-8",
	".txt": "text/plain; charset=utf-8",
};

function headersFor(filePath) {
	return {
		"Content-Type": MIME_TYPES[extname(filePath)] || "application/octet-stream",
		"Cross-Origin-Opener-Policy": "same-origin",
		"Cross-Origin-Embedder-Policy": "require-corp",
		"Cross-Origin-Resource-Policy": "cross-origin",
		"X-Content-Type-Options": "nosniff",
	};
}

function resolveRequestPath(requestUrl) {
	const url = new URL(requestUrl, `http://${HOST}:${PORT}`);
	const cleanPath = normalize(decodeURIComponent(url.pathname)).replace(/^(\.\.[/\\])+/, "");
	const requestedPath = resolve(join(WEB_ROOT, cleanPath));

	if (!requestedPath.startsWith(WEB_ROOT)) {
		return null;
	}

	if (existsSync(requestedPath) && statSync(requestedPath).isDirectory()) {
		return join(requestedPath, "index.html");
	}

	return requestedPath;
}

const server = createServer((request, response) => {
	const filePath = resolveRequestPath(request.url || "/");

	if (filePath === null || !existsSync(filePath) || !statSync(filePath).isFile()) {
		response.writeHead(404, {
			"Content-Type": "text/plain; charset=utf-8",
			"Cross-Origin-Opener-Policy": "same-origin",
			"Cross-Origin-Embedder-Policy": "require-corp",
			"Cross-Origin-Resource-Policy": "cross-origin",
		});
		response.end("Not found\n");
		return;
	}

	const fileSize = statSync(filePath).size;
	response.writeHead(200, {
		...headersFor(filePath),
		"Content-Length": fileSize,
	});

	createReadStream(filePath).pipe(response);
});

server.listen(PORT, HOST, () => {
	const scriptPath = fileURLToPath(import.meta.url);
	console.log(`Serving ${WEB_ROOT} at http://${HOST}:${PORT} via ${scriptPath}`);
});
