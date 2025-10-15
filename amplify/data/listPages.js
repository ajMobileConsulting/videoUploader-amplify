import { util } from "@aws-appsync/utils";

export function request(ctx) {
  return {
    method: "GET",
    resourcePath: "/wp/v2/pages",
    params: { headers: { "Content-Type": "application/json" } },
  };
}

export function response(ctx) {
  if (ctx.error) return util.error(ctx.error.message, ctx.error.type);

  var result = ctx.result || {};
  var statusCode = result.statusCode;
  var body = result.body;

  if (statusCode === 200 && body) {
    var pages = JSON.parse(body);
    return pages.map(function (page) {
      return {
        id: page.id,
        title: page.title && page.title.rendered ? page.title.rendered : "",
      };
    });
  }
  return util.appendError(body || "Unknown error", String(statusCode || 500));
}

module.exports = { request, response };   // ✅ absolutely required 