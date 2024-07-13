use std::env;

use ggez::{
    conf, event,
    glam::*,
    graphics::{self, Color},
    Context, GameResult,
};

struct MainState {
    pos_x: f32,
    circle: graphics::Mesh,
}

impl MainState {
    fn new(ctx: &mut Context) -> GameResult<MainState> {
        let circle = graphics::Mesh::new_circle(
            ctx,
            graphics::DrawMode::fill(),
            Vec2::new(0.0, 0.0),
            100.0,
            2.0,
            Color::WHITE,
        )?;
        Ok(MainState { pos_x: 0.0, circle })
    }
}
impl event::EventHandler<ggez::GameError> for MainState {
    fn update(&mut self, _ctx: &mut Context) -> GameResult {
        self.pos_x = self.pos_x % 900.0 + 1.0;
        Ok(())
    }

    fn draw(&mut self, ctx: &mut Context) -> GameResult {
        let mut canvas =
            graphics::Canvas::from_frame(ctx, graphics::Color::from([0.01, 0.2, 0.3, 1.0]));
        canvas.draw(&self.circle, Vec2::new(self.pos_x, 380.0));
        canvas.finish(ctx)?;
        Ok(())
    }
}

fn main() -> GameResult {
    let mut resource_dir = std::env::current_dir().unwrap();
    resource_dir.push("resources");

    println!("Resource directory: {:?}", resource_dir);

    let window_config = conf::WindowSetup {
        title: "Space Invaders".to_string(),
        samples: conf::NumSamples::One,
        vsync: true,
        icon: "/space-invaders-logo.png".to_string(),
        srgb: true,
    };

    let cb = ggez::ContextBuilder::new("space-invaders-rs", "0xcacti")
        .add_resource_path(resource_dir)
        .window_setup(window_config);
    let (mut ctx, event_loop) = cb.build()?;

    let state = MainState::new(&mut ctx)?;
    event::run(ctx, event_loop, state)
}
