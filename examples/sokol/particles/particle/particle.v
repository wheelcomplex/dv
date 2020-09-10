// Copyright(C) 2019 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package
module particle

import vec2
import sokol.sgl

const (
	default_life_time = 1000
	default_v_color   = Color{93, 136, 193, 255}
)

// * Module public
pub fn new(location vec2.Vec2) &Particle {
	p := &Particle{
		location: location
		velocity: vec2.Vec2{0, 0}
		acceleration: vec2.Vec2{0, 0}
		color: default_v_color
		life_time: default_life_time
		life_time_init: default_life_time
	}
	return p
}

fn remap(v, min, max, new_min, new_max f64) f64 {
	return (((v - min) * (new_max - new_min)) / (max - min)) + new_min
}

// * Particle
pub struct Particle {
mut:
	location       vec2.Vec2
	velocity       vec2.Vec2
	acceleration   vec2.Vec2
	color          Color
	life_time      f64
	life_time_init f64
}

pub fn (mut p Particle) update(dt f64) {
	mut acc := p.acceleration
	acc.multiply_f64(dt)
	p.velocity = p.velocity.add(acc)
	p.location = p.location.add(p.velocity)
	lt := p.life_time - (1000 * dt)
	if lt > 0 {
		p.life_time = lt
		p.color.r = p.color.r - 1 // byte(remap(p.life_time,0.0,p.life_time_init,0,p.color.r))
		p.color.g = p.color.g - 1 // byte(remap(p.life_time,0.0,p.life_time_init,0,p.color.g))
		p.color.b = p.color.b - 1 // byte(remap(p.life_time,0.0,p.life_time_init,0,p.color.b))
		// p.color.a = byte(remap(p.life_time,0.0,p.life_time_init,0,255))
	} else {
		p.life_time = 0
	}
}

pub fn (p Particle) is_dead() bool {
	return p.life_time <= 0.0
}

pub fn (p Particle) draw() {
	l := p.location
	sgl.c4b(p.color.r, p.color.g, p.color.b, p.color.a)
	lx := f32(l.x)
	ly := f32(l.y)
	sgl.v2f(lx, ly)
	sgl.v2f(lx + 2, ly)
	sgl.v2f(lx + 2, ly + 2)
	sgl.v2f(lx, ly + 2)
}

pub fn (mut p Particle) reset() {
	p.location.zero()
	p.acceleration.zero()
	p.velocity.zero()
	// p.color = Color{93, 136, 193, 255}
	p.color = default_v_color
	p.life_time = default_life_time
	p.life_time_init = p.life_time
}
