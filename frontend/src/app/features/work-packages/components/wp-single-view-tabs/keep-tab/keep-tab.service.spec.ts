

import { KeepTabService } from './keep-tab.service';

describe('keepTab service', () => {
  let callback:(transition:any) => void;
  const includes = (path:string) => false;
  let $state:any;
  let $transitions:any;
  let uiRouterGlobals:any;
  let keepTab:KeepTabService;
  let defaults:any;

  beforeEach(() => {
    $state = {
      current: {
        name: 'whatever',
      },
      includes,
    };

    $transitions = {
      onSuccess: (criteria:any, cb:(transition:any) => void) => callback = cb,
    };

    uiRouterGlobals = {
      params: { tabIdentifier: 'activity' },
    };

    keepTab = new KeepTabService($state, uiRouterGlobals, $transitions);

    defaults = {
      showTab: 'work-packages.show.tabs',
      detailsTab: 'work-packages.partitioned.list.details.tabs',
    };
  });

  describe('when initially invoked, or when an unsupported route is opened', () => {
    it('should have the correct default value for the currentShowTab', () => {
      expect(keepTab.currentShowTab).toEqual('activity');
    });

    it('should have the correct default value for the currentDetailsTab', () => {
      expect(keepTab.currentDetailsTab).toEqual('overview');
    });
  });

  describe('when opening a show route', () => {
    let currentPathPrefix = 'work-packages.show.*';

    beforeEach(() => {
      spyOn($state, 'includes').and.callFake((path:string) => path === currentPathPrefix);

      $state.current.name = 'work-packages.show.tabs';
      uiRouterGlobals.params.tabIdentifier = 'relations';
      keepTab.updateTabs();
    });

    it('should update the currentShowTab value', () => {
      expect(keepTab.currentShowTab).toEqual('relations');
    });

    it('should also update the value of currentDetailsTab', () => {
      expect(keepTab.currentShowTab).toEqual('relations');
    });

    it('should propagate the previous change', () => {
      const cb = jasmine.createSpy();

      const expected = {
        active: 'relations',
        show: 'relations',
        details: 'relations',
      };

      keepTab.observable.subscribe(cb);
      expect(cb).toHaveBeenCalledWith(expected);
    });

    it('should correctly change when switching back', () => {
      currentPathPrefix = '**.details.*';

      uiRouterGlobals.params.tabIdentifier = 'overview';
      keepTab.updateTabs();

      expect(keepTab.currentShowTab).toEqual('activity');
      expect(keepTab.currentDetailsTab).toEqual('overview');
    });
  });

  describe('when opening show#activity', () => {
    beforeEach(() => {
      spyOn($state, 'includes').and.callFake((path:string) => path === 'work-packages.show.*');

      uiRouterGlobals.params.tabIdentifier = 'activity';
      $state.current.name = 'work-packages.show.tabs';
      keepTab.updateTabs('activity');
    });

    it('should set the tab to overview', () => {
      expect(keepTab.currentDetailsTab).toEqual('overview');
    });
  });

  describe('when opening a details route', () => {
    beforeEach(() => {
      spyOn($state, 'includes').and.callFake((path:string) => path === '**.details.*');

      uiRouterGlobals.params.tabIdentifier = 'activity';
      $state.current.name = 'work-packages.partitioned.list.details.tabs';
      keepTab.updateTabs();
    });

    it('should update the currentShowTab value', () => {
      expect(keepTab.currentDetailsTab).toEqual('activity');
    });

    it('should also update the value of currentDetailsTab', () => {
      expect(keepTab.currentShowTab).toEqual('activity');
    });

    it('should propagate the previous and next change', () => {
      const cb = jasmine.createSpy();

      const expected = {
        active: 'activity',
        details: 'activity',
        show: 'activity',
      };

      keepTab.observable.subscribe(cb);
      expect(cb).toHaveBeenCalledWith(expected);

      keepTab.updateTabs();

      expect(cb.calls.count()).toEqual(2);
    });
  });
});
