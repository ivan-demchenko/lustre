// IMPORTS ---------------------------------------------------------------------

import gleam/dynamic
import gleam/string
import lustre
import lustre/attribute.{attribute}
import lustre/element.{Element, t}
import lustre/event
import lustre/html.{div, input, label, pre}

// MAIN ------------------------------------------------------------------------

pub fn main() {
  // A `simple` lustre application doesn't produce `Effect`s. These are best to 
  // start with if you're just getting started with lustre or you know you don't
  // need the runtime to manage any side effects.
  let app = lustre.simple(init, update, render)
  let assert Ok(_) = lustre.start(app, "[data-lustre-app]")

  Nil
}

// MODEL -----------------------------------------------------------------------

type Model {
  Model(email: String, password: String, remember_me: Bool)
}

fn init() -> Model {
  Model(email: "", password: "", remember_me: False)
}

// UPDATE ----------------------------------------------------------------------

type Msg {
  Typed(Input, String)
  Toggled(Control, Bool)
}

type Input {
  Email
  Password
}

type Control {
  RememberMe
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    Typed(Email, email) -> Model(..model, email: email)
    Typed(Password, password) -> Model(..model, password: password)
    Toggled(RememberMe, remember_me) -> Model(..model, remember_me: remember_me)
  }
}

// RENDER ----------------------------------------------------------------------

fn render(model: Model) -> Element(Msg) {
  div(
    [attribute.class("container")],
    [
      card([
        email_input(model.email),
        password_input(model.password),
        remember_checkbox(model.remember_me),
        pre([attribute.class("debug")], [t(string.inspect(model))]),
      ]),
    ],
  )
}

fn card(content: List(Element(a))) -> Element(a) {
  div([attribute.class("card")], [div([], content)])
}

fn email_input(value: String) -> Element(Msg) {
  render_input(Email, "email", "email-input", value, "Email address")
}

fn password_input(value: String) -> Element(Msg) {
  render_input(Password, "password", "password-input", value, "Password")
}

fn render_input(
  field: Input,
  type_: String,
  id: String,
  value: String,
  text: String,
) -> Element(Msg) {
  div(
    [attribute.class("input")],
    [
      label([attribute.for(id)], [t(text)]),
      input([
        attribute.id(id),
        attribute.name(id),
        attribute.type_(type_),
        attribute.required(True),
        attribute.value(dynamic.from(value)),
        event.on_input(fn(value) { Typed(field, value) }),
      ]),
    ],
  )
}

fn remember_checkbox(checked: Bool) -> Element(Msg) {
  div(
    [attribute.class("flex items-center")],
    [
      input([
        attribute.id("remember-me"),
        attribute.name("remember-me"),
        attribute.type_("checkbox"),
        attribute.checked(checked),
        attribute.class("checkbox"),
        event.on_click(Toggled(RememberMe, !checked)),
      ]),
      label([attribute.for("remember-me")], [t("Remember me")]),
    ],
  )
}
