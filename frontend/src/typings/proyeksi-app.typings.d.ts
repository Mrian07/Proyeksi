/**
 * API interfaces
 *
 * @see {@link http://opf.github.io/apiv3-doc/|Api V3 documentation}
 */

declare namespace api {

  /**
   * API v3
   */
  namespace v3 {
    interface Result {
      _links:any;
      _embedded:any;
      _type:string;
    }

    interface Collection extends Result {
      total:number;
      pageSize:number;
      count:number;
      offset:number;
      groups:any;
      totalSums:any;
    }

    interface Duration extends String {
    }

    interface Formattable {
      format?:string;
      raw:string;
      html?:string;
    }
  }
}

/**
 * ProyeksiApp interfaces
 */

interface Function {
  $link?:any;
  name:string;
  _type:string;
}

interface JQuery {
  topShelf:any;
  mark:any;
}

declare let Factory:any;

declare namespace op {
  interface QueryParams {
    offset?:number;
    pageSize?:number;
    filters?:any[];
    groupBy?:string;
    showSums?:boolean;
    sortBy?:any[];
  }
}
