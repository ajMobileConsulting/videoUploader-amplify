import { util } from "@aws-appsync/utils";

export function request(ctx: any) {
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

export function response(ctx: any) {
  if (ctx.error) {
    return util.error(ctx.error.message, ctx.error.type);
  }

  const { statusCode, body } = ctx.result;

  if (statusCode === 200) {
    // WordPress returns a top-level array of pages
    const pages = JSON.parse(body);

    // Optionally transform the data for your GraphQL shape
    return pages.map((page: any) => ({
      id: page.id,
      date: page.date,
      date_gmt: page.date_gmt,
      title: page.title?.rendered ?? "",
      content: page.content?.rendered ?? "",
    }));
  } else {
    return util.appendError(body, `${statusCode}`);
  }
}