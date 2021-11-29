

export class ExpressionService {
  // This is what returned by rails-angular-xss when it discovers double open curly braces
  // See https://github.com/opf/rails-angular-xss for more information.
  public static get UNESCAPED_EXPRESSION() {
    return '{{';
  }

  public static get ESCAPED_EXPRESSION() {
    return '{{ \\$root\\.DOUBLE_LEFT_CURLY_BRACE }}';
  }

  public static escape(input:string) {
    return input.replace(new RegExp(this.UNESCAPED_EXPRESSION, 'g'), this.ESCAPED_EXPRESSION);
  }

  public static unescape(input:string) {
    return input.replace(new RegExp(this.ESCAPED_EXPRESSION, 'g'), this.UNESCAPED_EXPRESSION);
  }
}
