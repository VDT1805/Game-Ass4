import { Schema, MapSchema, type } from "@colyseus/schema";

export class MyRoomState extends Schema {

  @type("string") mySynchronizedProperty: string = "Hello world";
  @type("string") currentClient: string = "";
  @type("boolean") is_x_turn: boolean = true;
}
