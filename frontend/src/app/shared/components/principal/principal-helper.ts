

export namespace PrincipalHelper {
  export type PrincipalType = 'user'|'placeholder_user'|'group';
  export type PrincipalPluralType = 'users'|'placeholder_users'|'groups';

  export function typeFromHref(href:string):PrincipalType|null {
    const match = /\/(user|group|placeholder_user)s\/\d+$/.exec(href);

    if (!match) {
      return null;
    }

    return match[1] as PrincipalType;
  }
}
