

import { OpenprojectHalModuleHelpers } from 'core-app/features/hal/helpers/lazy-accessor';

describe('lazy service', () => {
  const { lazy } = OpenprojectHalModuleHelpers;

  it('should exist', () => {
    expect(lazy).toBeDefined();
  });

  it('should add a property with the given name to the object', () => {
    const obj:any = {
      prop: void 0,
    };
    lazy(obj, 'prop', () => '');
    expect(obj.prop).toBeDefined();
  });

  it('should add an enumerable property', () => {
    const obj:any = {
      prop: void 0,
    };
    lazy(obj, 'prop', () => '');
    expect(obj.propertyIsEnumerable('prop')).toBeTruthy();
  });

  it('should add a configurable property', () => {
    const obj:any = {
      prop: void 0,
    };
    lazy(obj, 'prop', () => '');
    expect((Object as any).getOwnPropertyDescriptor(obj, 'prop').configurable).toBeTruthy();
  });

  it('should set the value of the property provided by the setter', () => {
    const obj:any = {
      prop: void 0,
    };
    lazy(obj, 'prop', () => '', (val:any) => val);
    obj.prop = 'hello';
    expect(obj.prop).toEqual('hello');
  });

  it('should not be settable, if no setter is provided', () => {
    const obj:any = {
      prop: void 0,
    };
    lazy(obj, 'prop', () => '');
    try {
      obj.prop = 'hello';
    } catch (Error) {}
    expect(obj.prop).not.toEqual('hello');
  });

  it('should do nothing if the target is not an object', () => {
    const obj:any = null;
    lazy(obj, 'prop', () => '');
    expect(obj).toBeNull();
  });
});
