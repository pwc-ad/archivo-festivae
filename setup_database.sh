#!/bin/bash

# Festival Archive Database Setup Script
# This script creates the database and runs all migrations

set -e  # Exit on any error

# Configuration
DB_NAME="festival_archive"
DB_USER="festival_user"
DB_PASSWORD="your_secure_password_here"
DB_HOST="localhost"
DB_PORT="5432"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🎭 Festival Archive Database Setup${NC}"
echo "=================================="

# Function to check if PostgreSQL is running
check_postgres() {
    echo -e "${YELLOW}Checking PostgreSQL connection...${NC}"
    if ! pg_isready -h $DB_HOST -p $DB_PORT; then
        echo -e "${RED}❌ PostgreSQL is not running or not accessible${NC}"
        echo "Please start PostgreSQL and try again"
        exit 1
    fi
    echo -e "${GREEN}✅ PostgreSQL is running${NC}"
}

# Function to create database and user
create_database() {
    echo -e "${YELLOW}Creating database and user...${NC}"
    
    # Create user (if not exists)
    psql -h $DB_HOST -p $DB_PORT -U postgres -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';" 2>/dev/null || echo "User already exists"
    
    # Create database (if not exists)
    psql -h $DB_HOST -p $DB_PORT -U postgres -c "CREATE DATABASE $DB_NAME OWNER $DB_USER;" 2>/dev/null || echo "Database already exists"
    
    # Grant privileges
    psql -h $DB_HOST -p $DB_PORT -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"
    
    echo -e "${GREEN}✅ Database and user created${NC}"
}

# Function to run migrations
run_migrations() {
    echo -e "${YELLOW}Running migrations...${NC}"
    
    # Set password for psql
    export PGPASSWORD=$DB_PASSWORD
    
    # Run each migration in order
    for migration in migrations/*.sql; do
        if [ -f "$migration" ]; then
            echo "Running: $(basename $migration)"
            psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f "$migration"
        fi
    done
    
    echo -e "${GREEN}✅ All migrations completed${NC}"
}

# Function to verify setup
verify_setup() {
    echo -e "${YELLOW}Verifying database setup...${NC}"
    
    # Check if tables exist
    table_count=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';")
    
    if [ "$table_count" -ge 9 ]; then
        echo -e "${GREEN}✅ Database setup verified (${table_count} tables created)${NC}"
    else
        echo -e "${RED}❌ Database setup verification failed${NC}"
        exit 1
    fi
}

# Function to show connection info
show_connection_info() {
    echo -e "${GREEN}🎉 Database setup completed successfully!${NC}"
    echo ""
    echo "Connection Information:"
    echo "======================"
    echo "Database: $DB_NAME"
    echo "User: $DB_USER"
    echo "Host: $DB_HOST"
    echo "Port: $DB_PORT"
    echo ""
    echo "To connect using psql:"
    echo "psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME"
    echo ""
    echo "Or set the PGPASSWORD environment variable:"
    echo "export PGPASSWORD='$DB_PASSWORD'"
    echo ""
    echo "Sample queries:"
    echo "==============="
    echo "SELECT * FROM artists;"
    echo "SELECT * FROM works_with_artists;"
    echo "SELECT * FROM edition_stats;"
}

# Main execution
main() {
    check_postgres
    create_database
    run_migrations
    verify_setup
    show_connection_info
}

# Run main function
main 