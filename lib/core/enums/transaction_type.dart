enum TransactionType {
  income('Pemasukan'),
  expense('Pengeluaran');

  final String label;
  const TransactionType(this.label);
}
