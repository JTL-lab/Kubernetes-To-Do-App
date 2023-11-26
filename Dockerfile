FROM python:3.9
LABEL authors="jtl2189"

# Set container working directory
WORKDIR /usr/src/app

# Copy current directory contents into /usr/src/app container
COPY . .

# Install requirements.txt packages/dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 5000 (used by default by Flask)
EXPOSE 5000
ENV FLASK_ENV=development

# Run app.py when the container launches
CMD ["python", "app.py"]
