import { shallow, render, mount } from 'enzyme';

// Jest, Enzyme, Snapshots
global.shallow = shallow;
global.render = render;
global.mount = mount;

global.shallowSnapshot = function(tree) {
  return global.matchSnapshot(shallow(tree));
};

global.renderSnapshot = function(tree) {
  return global.matchSnapshot(render(tree));
};

global.mountSnapshot = function(tree) {
  return global.matchSnapshot(mount(tree));
};

global.matchSnapshot = function(renderedComponent) {
  return expect(renderedComponent).toMatchSnapshot();
};
