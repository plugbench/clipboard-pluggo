package main

import (
	"context"
	"fmt"
	"log"

	"github.com/nats-io/nats.go"
	"golang.design/x/clipboard"
)

func sendLog(nc *nats.Conn, level, text string, args ...interface{}) {
	msg := nats.NewMsg("event.logged.clipboard-pluggo." + level)
	msg.Data = []byte(fmt.Sprintf(text, args...))
	nc.PublishMsg(msg)
}

func main() {
	if err := clipboard.Init(); err != nil {
		log.Fatal(err)
	}

	nc, err := nats.Connect(nats.DefaultURL)
	if err != nil {
		log.Fatal(err)
	}
	defer nc.Close()

	getCh := make(chan *nats.Msg, 32)
	getSub, err := nc.ChanSubscribe("cmd.get.clipboard", getCh)
	if err != nil {
		log.Fatal(err)
	}
	defer getSub.Drain()

	setCh := make(chan *nats.Msg, 32)
	setSub, err := nc.ChanSubscribe("cmd.put.clipboard", setCh)
	if err != nil {
		log.Fatal(err)
	}
	defer setSub.Drain()

	changeCh := clipboard.Watch(context.Background(), clipboard.FmtText)

	var contents []byte
	for {
		select {
		case msg := <-getCh:
			sendLog(nc, "info", "recieved get")
			reply := nats.NewMsg(msg.Reply)
			reply.Data = contents
			if err := nc.PublishMsg(reply); err != nil {
				sendLog(nc, "error", "error sending get reply: %v", err)
			}
		case msg := <-setCh:
			sendLog(nc, "info", "recieved set %q", string(msg.Data))
			clipboard.Write(clipboard.FmtText, msg.Data)
			reply := nats.NewMsg(msg.Reply)
			reply.Data = []byte("ok")
			if err := nc.PublishMsg(reply); err != nil {
				sendLog(nc, "error", "error sending set reply: %v", err)
			}
		case contents = <-changeCh:
			sendLog(nc, "info", "clipboard changed to %q", string(contents))
			event := nats.NewMsg("event.changed.clipboard")
			event.Data = contents
			if err := nc.PublishMsg(event); err != nil {
				sendLog(nc, "error", "error sending changed event: %v", err)
			}
		}
	}
}
