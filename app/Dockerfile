
########################
#####STAGE 0############
########################
FROM python:3.14-slim AS builder

# Working directory
WORKDIR /app

# Copy requirements
COPY requirements.txt .

# Install dependencies only
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

########################
#####STAGE 1############
########################

FROM python:3.14-alpine

WORKDIR /app

# Copy installed dependencies from builder
COPY --from=builder /install /usr/local

# Copy files to run app
COPY app/ .

# Execute command to run app
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]