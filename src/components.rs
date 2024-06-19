use bevy::prelude::*;

#[derive(Component, Clone, Copy)]
pub struct Player {
    pub handle: usize,
}

#[derive(Component, Clone, Copy)]
pub struct MoveDir(pub Vec2);

#[derive(Component, Clone, Copy)]
pub struct BulletReady(pub bool);

#[derive(Component, Clone, Copy)]
pub struct Bullet;

#[derive(Resource, Default, Clone, Copy, Debug)]
pub struct Scores(pub u32, pub u32);