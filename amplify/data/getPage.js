import { util } from "@aws-appsync/utils";

export function request(ctx) {
    return {
        method: "GET",
        resourcePath: "/wp-json/wp/v2/pages/" + ctx.arguments.id,
        params: {
            headers: {
                "Content-Type": "application/json",
            },
        },
    };
}

export function response(ctx) {
    if (ctx.error) {
        return util.error(ctx.error.message, ctx.error.type);
    }
    if (ctx.result.statusCode == 200) {
        
    var statusCode = ctx.result.statusCode;
    var body = ctx.result.body;

    if (statusCode === 200 && body) {
        const data = JSON.parse(body);
        return {
            id: data.id,
            title: data.title.rendered,
            date: data.date,
            date_gmt: data.date_gmt,
            content: data.content.rendered
        }
    } else {
        return util.appendError(body, statusCode);
    }
}
}