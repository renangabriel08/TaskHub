import 'package:flutter/material.dart';
import 'package:taskhub/config/app_colors.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  // Mock: true = professional, false = client
  bool _isProfessional = false;

  // Mock data for sent requests (client)
  final List<Map<String, dynamic>> _sentRequests = [
    {
      'id': 1,
      'professionalName': 'Carlos Eletricista',
      'service': 'Instalação Elétrica',
      'status': 'pendente',
      'date': '17/03/2026',
      'time': '14:00',
      'location': 'Rua A, 123 - Centro',
      'avatar': '👨‍🔧',
      'problemDescription': 'Instalação de novo painel elétrico',
    },
    {
      'id': 2,
      'professionalName': 'Lucas Encanador',
      'service': 'Manutenção Preventiva',
      'status': 'aceito',
      'date': '15/03/2026',
      'time': '10:00',
      'location': 'Rua B, 456 - Vila Nova',
      'avatar': '🔧',
      'problemDescription': 'Vazamento em cano de cobre',
    },
    {
      'id': 3,
      'professionalName': 'Marina Design',
      'service': 'Reparo de Emergência',
      'status': 'recusado',
      'date': '14/03/2026',
      'time': '16:30',
      'location': 'Rua C, 789 - Bairro',
      'avatar': '👩‍🎨',
      'problemDescription': 'Problema urgente na rede elétrica',
    },
  ];

  // Mock data for received requests (professional)
  final List<Map<String, dynamic>> _receivedRequests = [
    {
      'id': 1,
      'clientName': 'João Silva',
      'service': 'Instalação Elétrica',
      'status': 'pendente',
      'date': '17/03/2026',
      'time': '14:00',
      'location': 'Rua A, 123 - Centro',
      'avatar': '👤',
      'problemDescription': 'Instalação de novo painel elétrico',
      'rating': 4.5,
      'reviews': 23,
    },
    {
      'id': 2,
      'clientName': 'Maria Santos',
      'service': 'Manutenção Preventiva',
      'status': 'aceito',
      'date': '16/03/2026',
      'time': '11:00',
      'location': 'Rua B, 456 - Vila Nova',
      'avatar': '👤',
      'problemDescription': 'Inspeção de sistema elétrico completo',
      'rating': 4.8,
      'reviews': 45,
    },
  ];

  void _acceptRequest(int id) {
    setState(() {
      final index = _receivedRequests.indexWhere((r) => r['id'] == id);
      if (index != -1) {
        _receivedRequests[index]['status'] = 'aceito';
      }
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Solicitação aceita!')));
  }

  void _rejectRequest(int id) {
    setState(() {
      final index = _receivedRequests.indexWhere((r) => r['id'] == id);
      if (index != -1) {
        _receivedRequests[index]['status'] = 'recusado';
      }
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Solicitação recusada')));
  }

  Future<void> _proposeReschedule(int id) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );

    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    final proposedDate =
        '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
    final proposedTime =
        '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';

    setState(() {
      final index = _receivedRequests.indexWhere((r) => r['id'] == id);
      if (index != -1) {
        _receivedRequests[index]['status'] = 'proposta_reagendamento';
        _receivedRequests[index]['proposedDate'] = proposedDate;
        _receivedRequests[index]['proposedTime'] = proposedTime;
      }
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Proposta enviada: $proposedDate às $proposedTime'),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pendente':
        return Colors.orange;
      case 'aceito':
        return Colors.green;
      case 'recusado':
        return Colors.red;
      case 'proposta_reagendamento':
        return AppColors.primary;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'pendente':
        return 'Pendente';
      case 'aceito':
        return 'Aceito';
      case 'recusado':
        return 'Recusado';
      case 'proposta_reagendamento':
        return 'Proposta de Reagendamento';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle between client and professional view
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isProfessional = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !_isProfessional ? AppColors.primary : null,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Enviados',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: !_isProfessional
                                ? Colors.white
                                : AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isProfessional = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _isProfessional ? AppColors.primary : null,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Recebidos',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _isProfessional
                                ? Colors.white
                                : AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Requests List
            if (!_isProfessional)
              ..._buildSentRequestsList()
            else
              ..._buildReceivedRequestsList(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSentRequestsList() {
    return _sentRequests.map((request) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Professional Info
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        request['avatar'],
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request['professionalName'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          request['service'],
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        request['status'],
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusLabel(request['status']),
                      style: TextStyle(
                        color: _getStatusColor(request['status']),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Problem Description
              Text(
                request['problemDescription'],
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 10),
              // Date, Time, Location
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    request['date'],
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    request['time'],
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      request['location'],
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildReceivedRequestsList() {
    return _receivedRequests.map((request) {
      bool isPending = request['status'] == 'pendente';

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Client Info
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        request['avatar'],
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request['clientName'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${request['rating']} (${request['reviews']})',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        request['status'],
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusLabel(request['status']),
                      style: TextStyle(
                        color: _getStatusColor(request['status']),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Service Info
              Row(
                children: [
                  Icon(Icons.build, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    request['service'],
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Problem Description
              Text(
                request['problemDescription'],
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 10),
              // Date, Time, Location
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    request['date'],
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    request['time'],
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      request['location'],
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (request['status'] == 'proposta_reagendamento') ...[
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    'Nova proposta: ${request['proposedDate']} às ${request['proposedTime']}',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              // Accept/Reject Buttons (only if pending)
              if (isPending) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _rejectRequest(request['id']),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                        child: const Text('Recusar'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _acceptRequest(request['id']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text(
                          'Aceitar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _proposeReschedule(request['id']),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                    ),
                    icon: const Icon(Icons.schedule),
                    label: const Text('Reagendar'),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }).toList();
  }
}
