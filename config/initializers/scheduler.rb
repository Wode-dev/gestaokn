require 'rufus-scheduler'

$scheduler = Rufus::Scheduler.new

Secret.all.update(block_schedule_id: "")

# Teste
$scheduler.cron '*/5 * * * *' do
    puts "Cron de 5 em 5 minutos executado"
    #BillJob.perform_now
end

# Todo dia 6, às 2 horas da manhã no horário do nordeste
$scheduler.cron '0 2 6 * * America/Fortaleza' do
    BillJob.perform_now
end

$scheduler.cron '0 0 * * * America/Fortaleza' do
    PendencyJob.perform_now
end