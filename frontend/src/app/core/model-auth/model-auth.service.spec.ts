

/* jshint expr: true */

import { AuthorisationService } from './model-auth.service';

describe('authorisationService', () => {
  const authorisationService:AuthorisationService = new AuthorisationService();

  describe('model action authorisation', () => {
    beforeEach(() => {
      authorisationService.initModelAuth('query', {
        create: '/queries',
      });
    });

    it('should allow action', () => {
      expect(authorisationService.can('query', 'create')).toBeTruthy();
      expect(authorisationService.cannot('query', 'create')).toBeFalsy();
    });

    it('should not allow action', () => {
      expect(authorisationService.can('query', 'delete')).toBeFalsy();
      expect(authorisationService.cannot('query', 'delete')).toBeTruthy();
    });
  });
});
