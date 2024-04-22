import { Room, Client } from "@colyseus/core";
import { MyRoomState } from "./schema/MyRoomState";
import { type, Schema, MapSchema, ArraySchema } from '@colyseus/schema';
// class BoardState extends Schema {
//   // @type("string") currentTurn: string;
//   @type({ map: "boolean" }) players: MapSchema<boolean> = new MapSchema<boolean>();
//   // @type(["number"]) board: number[] = new ArraySchema<number>(0, 0, 0, 0, 0, 0, 0, 0, 0);
//   // @type("string") winner: string;
//   // @type("boolean") draw: boolean;
// }


export class MyRoom extends Room {
  maxClients = 2;
  otherClient = "";
  temp = "";
  onCreate (options: any) {
    this.setState(new MyRoomState());

    //when a message is received of type "message," broadcast it with the type "server-message" to all clients
    this.onMessage("message", (client, message) => {
      console.log("Game Room received message from", client.sessionId, ":", message);
      
      this.broadcast("server-message", `(${client.sessionId} ${message}`);
  });


  //when a message is received of type "game-message," broadcast it with the type "game-message" to all clients except for the one that sent it
  this.onMessage("game-message", (client, message) => {
      console.log("Game Room received game message from", client.sessionId, ":", message)
      this.broadcast("game-message", message, { except: client });
      this.temp = this.state.currentClient;
      this.state.currentClient = this.otherClient;
      this.otherClient = this.temp;
      console.log("Current Client: ", this.state.currentClient);
      console.log("Other Client: ", this.otherClient);
  });

  //when a message is received of type "client-request", respond to the sending client with the appropriate data
  this.onMessage("client-request", (client, message) => {
      client.send("client-request", message);
  })
  
  }

  //determine what should happen when a client joins
  onJoin(client: Client, options: any) {
    console.log(client.sessionId, "joined!");
    if (this.state.currentClient === "") {
      this.state.currentClient = client.sessionId;
    }
    else {
      this.otherClient = client.sessionId;
    }
    console.log("Current Client: ", this.state.currentClient);
    console.log("Other Client: ", this.otherClient);
    this.broadcast("server-message", `${client.sessionId} joined.`);
}

//determine what should happen when a client leaves
onLeave(client: Client, consented: any) {
    console.log(client.sessionId, "left!");
    this.broadcast("server-message", `${client.sessionId} left.`);
}

//determine what should happen when a room is closed
onDispose() {
    console.log("room", this.roomId, "disposing...");
}

}
