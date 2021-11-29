

/* jshint expr: true */

import { HookService } from 'core-app/features/plugins/hook-service';

describe('HookService', () => {
  let service:HookService = new HookService();

  let callback:any; let
    invalidCallback:any;
  const validId = 'myValidCallbacks';

  beforeEach(() => {
    service = new HookService();
  });

  const shouldBehaveLikeEmptyResult = function (id:string) {
    it('returns empty results', () => {
      expect(service.call(id).length).toEqual(0);
    });
  };

  const shouldBehaveLikeResultWithElements = function (id:string, count:number) {
    it('returns #count results', () => {
      expect(service.call(id).length).toEqual(count);
    });
  };

  const shouldBehaveLikeCalledCallback = function (id:string) {
    beforeEach(() => {
      service.call(id);
    });

    it('is called', () => {
      expect(callback).toHaveBeenCalled();
    });
  };

  const shouldBehaveLikeUncalledCallback = function (id:string) {
    beforeEach(() => {
      service.call(id);
    });

    it('is not called', () => {
      expect(invalidCallback.called).toBeFalsy();
    });
  };

  describe('register', () => {
    const invalidId = 'myInvalidCallbacks';

    describe('no callback registered', () => {
      shouldBehaveLikeEmptyResult(invalidId);
    });

    describe('valid function callback registered', () => {
      beforeEach(() => {
        callback = jasmine.createSpy('hook');
        service.register('myValidCallbacks', callback);
      });

      shouldBehaveLikeEmptyResult(validId);

      shouldBehaveLikeCalledCallback(validId);
    });
  });

  describe('call', () => {
    describe('function that returns undefined', () => {
      beforeEach(() => {
        callback = jasmine.createSpy('hook');
        service.register('myValidCallbacks', callback);
      });

      shouldBehaveLikeCalledCallback(validId);

      shouldBehaveLikeEmptyResult(validId);
    });

    describe('function that returns something that is not undefined', () => {
      beforeEach(() => {
        callback = jasmine.createSpy('hook').and.returnValue({});

        service.register('myValidCallbacks', callback);
      });

      shouldBehaveLikeCalledCallback(validId);

      shouldBehaveLikeResultWithElements(validId, 1);
    });

    describe('function that returns something that is not undefined', () => {
      beforeEach(() => {
        callback = jasmine.createSpy('hook').and.returnValue({});

        service.register('myValidCallbacks', callback);
      });

      shouldBehaveLikeCalledCallback(validId);

      shouldBehaveLikeResultWithElements(validId, 1);
    });

    describe('function that returns something that is not undefined', () => {
      beforeEach(() => {
        callback = jasmine.createSpy('hook');
        invalidCallback = jasmine.createSpy('invalidHook');

        service.register('myValidCallbacks', callback);

        service.register('myInvalidCallbacks', invalidCallback);
      });

      shouldBehaveLikeCalledCallback(validId);

      shouldBehaveLikeUncalledCallback(validId);
    });

    describe('function that returns something that is not undefined', () => {
      let callback1; let
        callback2;

      beforeEach(() => {
        callback1 = jasmine.createSpy('hook1').and.returnValue({});
        callback2 = jasmine.createSpy('hook1').and.returnValue({});

        service.register('myValidCallbacks', callback1);
        service.register('myValidCallbacks', callback2);
      });

      shouldBehaveLikeResultWithElements(validId, 2);
    });
  });
});
