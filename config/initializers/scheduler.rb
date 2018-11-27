require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

# Teste
scheduler.cron '*/5 * * * *' do
    puts "Cron de 5 em 5 minutos executado"
    #BillJob.perform_now
end

# Todo dia 5, às 23 horas no horário do nordeste
scheduler.cron '0 23 5 * * America/Fortaleza' do
    BillJob.perform_now
end

scheduler.cron '0 0 * * * America/Fortaleza' do
    PendencyJob.perform_now
end