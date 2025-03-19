#!/bin/bash
export API_ENV=development
uvicorn src.main:app --reload --port 8000