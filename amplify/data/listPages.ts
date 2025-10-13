import { util, Context } from "@aws-appsync/utils";

export function request(ctx: Context) {
  return {
    method: "GET",
    resourcePath: "/wp-json/wp/v2/pages",
    params: {
      headers: {
        "Content-Type": "application/json",
      },
    },
  };
}

export function response(ctx: Context) {
  if (ctx.error) {
    return util.error(ctx.error.message, ctx.error.type);
  }
  if (ctx.result.statusCode === 200) {
    return JSON.parse(ctx.result.body).data;
  } else {
    return util.appendError(ctx.result.body, "ctx.result.statusCode");
  }
}