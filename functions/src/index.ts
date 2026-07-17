/* eslint-disable max-len */
import * as functions from "firebase-functions";
import express from "express";
import cors from "cors";
import { OpenAI } from "openai";

const app = express();
app.use(cors({ origin: true }));
app.use(express.json());

const openai = new OpenAI({
  apiKey: "",
});

app.post("/chat", async (req, res) => {
  try {
    const { message, systemInstruction } = req.body;

    if (!message) {
      res.status(400).json({
        status: 400,
        error: "Bad Request",
        message: "User message is required.",
      });
      return;
    }

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const messages: any[] = [];

    if (systemInstruction) {
      messages.push({ role: "system", content: systemInstruction });
    }
    messages.push({ role: "user", content: message });

    const completion = await openai.chat.completions.create({
      model: "gpt-3.5-turbo",
      messages: messages,
      temperature: 0.7,
    });

    const aiResponse = completion.choices[0].message?.content;

    res.status(200).json({
      answer: aiResponse,
      model: "gpt-3.5-turbo",
      advisory: true,
    });
    return;
  } catch (error) {
    res.status(503).json({
      status: 503,
      error: "Service Unavailable",
      message: "The AI Assistant is down. Please try again later.",
      details: String(error),
    });
    return;
  }
});

export const api = functions.https.onRequest(app);
