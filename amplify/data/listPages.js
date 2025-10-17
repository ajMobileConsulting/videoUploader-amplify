import { util } from "@aws-appsync/utils";

export function request(ctx) {
  return {
    method: "GET",
    resourcePath: "/wp-json/wp/v2/pages",
    params: {
      headers: {
        "Content-Type": "application/json"
      }
    },
  };
}

export function response(ctx) {
  if (ctx.error) return util.error(ctx.error.message, ctx.error.type);

  var result = ctx.result || {};
  var statusCode = result.statusCode;
  var body = result.body;

  if (statusCode === 200 && body) {
    var pages = JSON.parse(body);

    var result = pages.map(data => ({
      id: data.id,
      title: data.title.rendered,
      date: data.date,
      date_gmt: data.date_gmt,
      content: data.content.rendered
    }));

    return result;
  } else {
    return util.appendError(body, statusCode);
  }

}

